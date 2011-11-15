class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  embeds_many :timers
  embedded_in :user

  def is_timer_currently_running?
    currently_running_timer != nil
  end

  def is_timer_currently_paused?
    currently_paused_timer != nil
  end

  def currently_running_timer
    timers.where(state: 'started').first
  end

  def currently_paused_timer
    timers.where(state: 'paused').first
  end

  def start
    unless is_timer_currently_running?
      timers.create.start
    end
  end

  def pause
    if is_timer_currently_paused?
      currently_paused_timer.unpause
    elsif is_timer_currently_running?
      currently_running_timer.pause
    end
  end

  def stop
    if is_timer_currently_running?
      currently_running_timer.stop
    elsif is_timer_currently_paused?
      currently_paused_timer.stop
    end
  end
end
