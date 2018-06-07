module Arask
  class AraskJob < ActiveRecord::Base
    def run
      self.update_attribute(:execute_at, self.interval.seconds.from_now)
      begin
        eval(self.job)
      rescue
        # TODO: Alert broken job
      end
    end
  end
end
