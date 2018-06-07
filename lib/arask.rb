require "arask/railtie"
require "arask/arask_job"

module Arask
  class << self; attr_accessor :time_cache; end

  def self.setup
    @jobs_touched = []
    yield Arask
    begin
      AraskJob.all.where.not(id: @jobs_touched).delete_all
    rescue
    end
  end

  def self.create(script:, interval:, run_first_time: false)
    case interval
    when :hourly
      interval = 1.hour
    when :daily
      interval = 1.day
    when :monthly
      interval = 1.month
    end
    interval = interval.to_s.to_i
    begin
      job = AraskJob.where(job: script, interval: interval).first
      if job
        @jobs_touched << job.id
      else
        job = AraskJob.create(job: script, interval: interval, execute_at: interval.seconds.from_now)
        @jobs_touched << job.id
        if run_first_time===true
          job.run
        end
      end
    rescue ActiveRecord::StatementInvalid => e
      puts 'Could not create arask job! Looks like the database is not migrated? Remember to run `rails generate arask:install` and `rails db:migrate`'
    end
  end

  ActionController::Base.instance_eval do
    after_action do
      Arask.time_cache ||= Time.now
      if Arask.time_cache <= Time.now
        AraskJob.where('execute_at < ?', DateTime.now).each do |job|
          job.run
        end
        Arask.time_cache = 5.minutes.from_now
      end
    end
  end
end
