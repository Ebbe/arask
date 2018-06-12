require "arask/railtie"
require "arask/arask_job"

module Arask
  class << self; attr_accessor :time_cache; end

  def self.setup
    @jobs_touched = []
    yield Arask
    begin
      AraskJob.all.where.not(id: @jobs_touched).delete_all
      Arask.queue_self
    rescue
    end
  end

  def self.queue_self
    begin
      next_job_run = AraskJob.order(execute_at: :asc).first.try(:execute_at)
      # At least check database for jobs every 5 minutes
      next_job_run = 5.minutes.from_now if next_job_run.nil? or (next_job_run - DateTime.now)/60 > 5
      RunJobs.set(wait_until: next_job_run).perform_later
    rescue
    end
  end

  def self.create(script: nil, task: nil, interval:, run_first_time: false)
    case interval
    when :hourly
      interval = 1.hour
    when :daily
      interval = 1.day
    when :monthly
      interval = 1.month
    end
    interval = interval.to_s.to_i
    unless task.nil?
      script = "Rake::Task['#{task}'].invoke"
    end
    if script.nil?
      puts 'Arask: You did not specify a script or task to run!'
      return
    end
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


  class RunJobs < ActiveJob::Base
    queue_as :default

    def perform
      begin
        AraskJob.transaction do
          AraskJob.where('execute_at < ?', DateTime.now).lock.each do |job|
            job.run
          end
        end
      rescue
      end
      Arask.queue_self
    end
  end
end
