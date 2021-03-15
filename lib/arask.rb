require "arask/railtie"
require "arask/arask_job"
require "arask/run_jobs"
require "arask/setup"
require 'fugit' # To parse cron

module Arask
  class << self; attr_accessor :jobs_touched, :exception_email, :exception_email_from, :exception_block, :jobs_block; end

  def self.setup(force_run = false, &block)
    Arask.jobs_block = block
    # Make sure we only run setup now if we are testing.
    # Else we would run them at every cli execution.
    # railtie.rb inits the jobs when the server is ready
    Arask.init_jobs if force_run
  end

  def self.init_jobs
    Arask.jobs_touched = []
    Arask.jobs_block.call(Setup)
    Arask.jobs_block = nil
    begin
      AraskJob.all.where.not(id: Arask.jobs_touched).delete_all
      Arask.jobs_touched = nil
      Arask.queue_self
    rescue
    end
  end

  def self.queue_self
    begin
      next_job_run = AraskJob.order(execute_at: :asc).first.try(:execute_at)
      # At least check database for jobs every day
      next_job_run = 1.day.from_now if next_job_run.nil? or (next_job_run - DateTime.now)/60/60 > 24
      RunJobs.set(wait_until: next_job_run).perform_later
    rescue
    end
  end

end
