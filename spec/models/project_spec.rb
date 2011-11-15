require 'spec_helper'

describe Project do
  describe "Timers" do

    let(:user) { Factory(:user) }
    let(:project) { Factory(:project, :user => user) }

    it "should have no timers when created" do
      project.timers.should be_empty
    end

    describe "#start" do
      it "should create a timer if there isn't one running" do
        expect { project.start }.to change(project.timers, :count).by(1)
      end

      it "should not do anything if there is already a timer running" do
        project.start
        expect { project.start }.to change(project.timers, :count).by(0)
      end
    end

    describe "#pause" do
      it "should do nothing if there is no currently running timer" do
        expect { project.pause }.to change(project.timers.where({ state: 'paused'}), :count).by(0)
      end

      it "should pause the current running timer if there is one" do
        project.start
        project.timers.where({state: 'paused'}).should be_empty
        project.pause
        project.timers.where({state: 'paused'}).count.should == 1
      end

      it "should unpause the currently paused timer if there is one" do
        project.start
        project.pause
        project.timers.where({state: 'paused'}).count.should == 1
        project.pause
        project.timers.where({state: 'paused'}).should be_empty
      end
    end

    describe "#stop" do
      it "shouldn't do anything if there is no running timer" do
        expect { project.stop }.to change(project.timers.where({ state: 'started' }), :count).by(0)
      end

      it "should stop the currently running timer if there is one" do
        project.start
        project.timers.where({state: 'started'}).count.should == 1
        project.stop
        project.timers.where({state: 'started'}).should be_empty
      end

      it "should stop the currently paused timer if there is one" do
        project.start
        project.pause
        project.timers.where({state: 'paused'}).count.should == 1
        project.stop
        project.timers.where({state: 'paused'}).should be_empty
        project.timers.where({state: 'started'}).should be_empty
      end
    end
  end
end
