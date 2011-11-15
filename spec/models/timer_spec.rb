require 'spec_helper'

describe Timer do

  let(:user) { Factory(:user) }
  let(:project) { Factory(:project, :user => user) }
  let(:timer) { Factory(:timer, :project => project) }
  let(:now) { Time.now }

  before(:each) { Timecop.freeze(now) }
  after(:each) { Timecop.return }

  describe "transitions" do

    describe "start" do

      before(:each) { timer.start }

      it "should set the start_time" do
        timer.start_time.should be_the_same_time_as(Time.now)
      end

      it "should set the current_start_time" do
        timer.current_start_time.should be_the_same_time_as(Time.now)
      end

      it "should not do anything with total_seconds" do
        timer.total_time_in_sec.should == 0
      end

      it "total_time should show the running time" do
        Timecop.freeze(now + 60.seconds)
        timer.total_time.should == 60
      end
    end

    describe "end" do

      before(:each) do
        timer.start
        Timecop.freeze(now + 60.seconds)
        timer.stop
      end

      it "should set the end_time" do
        timer.end_time.should be_the_same_time_as(now + 60.seconds)
      end

      it "should set the total_seconds" do
        timer.total_time_in_sec.should == 60
      end

      it "total_time should show the total time" do
        timer.total_time.should == 60
      end
    end

    describe "pause" do

      before(:each) do
        timer.start
        Timecop.freeze(now + 60.seconds)
        timer.pause
      end

      it "should set the current_end_time" do
        timer.current_end_time.should be_the_same_time_as(now + 60.seconds)
      end

      it "should set the total seconds" do
        timer.total_time_in_sec.should == 60
      end

      it "should show the total time" do
        timer.total_time.should == 60
      end
    end

    describe "unpause" do
      before(:each) do
        timer.start
        Timecop.freeze(now + 60.seconds)
        timer.pause
        Timecop.freeze(now + 120.seconds)
        timer.unpause
      end

      it "should update the current_start_time" do
        timer.current_start_time.should be_the_same_time_as(now + 120.seconds)
      end

      it "should clear out current_end_time" do
        timer.current_end_time.should be_nil
      end

      it "should show the total time" do
        timer.total_time.should == 60
      end
    end

    describe "multiple pauses" do
      it "should correctly calculate the total seconds" do
        timer.start
        Timecop.freeze(now + 60.seconds)
        timer.pause
        Timecop.freeze(now + 120.seconds)
        timer.unpause
        Timecop.freeze(now + 180.seconds)
        timer.pause
        Timecop.freeze(now + 500.seconds)
        timer.unpause
        Timecop.freeze(now + 560.seconds)
        timer.stop

        timer.total_time_in_sec.should == 180
        timer.start_time.should be_the_same_time_as(now)
        timer.end_time.should be_the_same_time_as(now + 560.seconds)
      end

      it "should correctly show the total seconds if the timer is still running" do
        timer.start
        Timecop.freeze(now + 60.seconds)
        timer.pause
        Timecop.freeze(now + 120.seconds)
        timer.unpause
        Timecop.freeze(now + 180.seconds)
        timer.pause
        Timecop.freeze(now + 500.seconds)
        timer.unpause
        Timecop.freeze(now + 560.seconds)
        timer.total_time.should == 180
        Timecop.freeze(now + 602.seconds)
        timer.total_time.should == 222
      end
    end

  end
end
