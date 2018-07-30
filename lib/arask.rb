require "arask/railtie"
require "arask/arask_job"
require "arask/run_jobs"
require "arask/setup"
require 'fugit' # To parse cron

module Arask
  class << self; attr_accessor :jobs_touched, :exception_email, :exception_email_from, :exception_block; end

  def self.setup(force_run = false)
    # Make sure we only run setup if Rails is actually run as a server or testing.
    return unless defined?(Rails::Server) or force_run
    # If we don't wait and rails is setup to use another language, ActiveJob
    # saves what is now (usually :en) and reloads that when trying to run the
    # job. Renderering an I18n error of unsupported language.
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
      # At least check database for jobs every day
      next_job_run = 1.day.from_now if next_job_run.nil? or (next_job_run - DateTime.now)/60/60 > 24
      RunJobs.set(wait_until: next_job_run).perform_later
    rescue
    end
  end

end
