module Arask
  require 'rake'

  class AraskJob < ActiveRecord::Base
    def run
      self.update_attribute(:execute_at, self.interval.seconds.from_now)
      begin
        if self.job.start_with?('Rake::Task')
          Rake.load_rakefile Rails.root.join( 'Rakefile' )
        end
        eval(self.job)
      rescue Exception => e
        puts 'Arask: Job failed'
        p self
        puts e.message

        unless Arask.exception_email.nil?
          ActionMailer::Base.mail(
            from: Arask.exception_email_from,
            to: Arask.exception_email,
            subject: "Arask failed",
            body: "Job: #{self.inspect}\n\nException:\n#{e.message}"
          ).deliver
        end
      end
    end
  end
end
