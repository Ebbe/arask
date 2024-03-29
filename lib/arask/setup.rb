module Arask
  class Setup
    def self.on_exception(email: nil, from: 'robot@server', &block)
      Arask.exception_email = email unless email.nil?
      Arask.exception_email_from = from unless from.nil?
      puts "Arask could not parse parameter for on_exception!" unless email.nil? or email.class == String
      if block_given?
        Arask.exception_block = block
      end
    end

    def self.create(script: nil, task: nil, job: nil, interval: nil, cron: nil, run_first_time: false)
      interval = parse_interval_or_cron(interval, cron)
      if interval.nil?
        puts 'Arask: You did not specify neither cron: nor interval:! When should the task run?'
        return
      end
      unless task.nil?
        script = "Rake::Task['#{task}']"
      end
      unless job.nil?
        script = "#{job}.perform_now"
      end
      if script.nil?
        puts 'Arask: You did not specify a script or task to run!'
        return
      end
      begin
        job = AraskJob.where(job: script, interval: interval).first
        if job
          Arask.jobs_touched << job.id
        else
          job = AraskJob.create(job: script, interval: interval)
          Arask.jobs_touched << job.id
          if run_first_time===true
            job.update_attribute(:execute_at, Time.now)
          end
        end
      rescue ActiveRecord::StatementInvalid => e
        puts 'Could not create arask job! Looks like the database is not migrated? Remember to run `rails generate arask:install` and `rails db:migrate`'
      end
    end

    private
    def self.parse_interval_or_cron(interval, cron)
      unless interval.nil?
        case interval
        when :hourly
          interval = 1.hour
        when :daily
          interval = 1.day
        when :monthly
          interval = 1.month
        end
        interval = interval.to_s.to_i
      end
      unless cron.nil?
        interval = 'cron: ' + cron
      end
      return interval
    end

  end
end
