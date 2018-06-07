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
        # TODO: Alert broken job
        puts 'Arask: Job failed'
        p self
        puts e.message
      end
    end
  end
end
