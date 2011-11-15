class Timer
  include Mongoid::Document
  include Mongoid::Timestamps
  require 'pp'
  field :start_time, :type => Time
  field :end_time, :type => Time
  field :total_time_in_sec, :type => Integer, :default => 0
  field :current_start_time, :type => Time
  field :current_end_time, :type => Time

  embedded_in :project

  state_machine :initial => :stopped do

    event :start do
      transition :stopped => :started
    end
    before_transition :stopped => :started, :do => [:set_start_time, :set_current_start_time]

    event :pause do
      transition :started => :paused
    end
    before_transition :started => :paused, :do => [:set_current_end_time, :calculate_total_time]

    event :unpause do
      transition :paused => :started
    end
    before_transition :paused => :started, :do => [:set_current_start_time, :clear_current_end_time]

    event :stop do
      transition [:started, :paused] => :stopped
    end
    before_transition [:started, :paused] => :stopped, :do => [:set_end_time, :set_current_end_time, :calculate_total_time]
  end

  def set_start_time
    self.start_time = Time.now
  end

  def set_end_time
    self.end_time = Time.now
  end

  def set_current_start_time
    self.current_start_time = Time.now
  end

  def set_current_end_time
    self.current_end_time = Time.now
  end

  def clear_current_end_time
    self.current_end_time = nil
  end

  def total_time
    if self.state?(:started)
      self.total_time_in_sec + (Time.now.to_i - self.current_start_time.to_i)
    else
      self.total_time_in_sec
    end
  end

  def calculate_total_time
    self.total_time_in_sec += (self.current_end_time.to_i - self.current_start_time.to_i)
  end
end
