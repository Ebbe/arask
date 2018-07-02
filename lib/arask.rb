require "arask/railtie"
require "arask/arask_job"
require "arask/run_jobs"
require "arask/setup"
require 'fugit' # To parse cron

module Arask
  class << self; attr_accessor :jobs_touched, :exception_email, :exception_email_from; end

  def self.setup
    # Make sure we only run setup if Rails is actually run as a server or testing.
    return unless defined?(Rails::Server) or Rails.env.test?
    ActiveSupport.on_load :after_initialize, yield: true do
      Arask.jobs_touched = []
      yield Setup
      begin
        AraskJob.all.where.not(id: Arask.jobs_touched).delete_all
        Arask.queue_self
      rescue
      end
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

end
