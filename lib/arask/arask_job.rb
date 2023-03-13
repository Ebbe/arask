module Arask
  require 'rake'

  class AraskJob < ActiveRecord::Base
    after_create :calculate_new_execute_at

    def run
      calculate_new_execute_at
      begin
        if self.job.start_with?('Rake::Task')
          Rake.load_rakefile Rails.root.join('Rakefile') unless Rake::Task.task_defined?(self.job[12..-3])
          eval(self.job + '.invoke')
          eval(self.job + '.reenable')
        else
          eval(self.job)
        end
      rescue Exception => e
        puts 'Arask: Job failed'
        p self
        puts e.message

        unless Arask.exception_block.nil?
          Arask.exception_block.call(e, self)
        end
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

    private
    def calculate_new_execute_at
      if self.interval.start_with?('cron: ')
        cron = Fugit::Cron.parse(self.interval.split(' ', 2)[1])
        self.update_attribute(:execute_at, cron.next_time.to_t)
      else
        self.update_attribute(:execute_at, self.interval.to_i.seconds.from_now)
      end
    end
  end
end
