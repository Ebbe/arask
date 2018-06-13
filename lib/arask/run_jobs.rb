module Arask
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
