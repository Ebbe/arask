module Arask
  class Setup
    def self.on_exception(email: nil, from: 'robot@server')
      Arask.exception_email = email
      Arask.exception_email_from = from
      puts "Arask could not parse parameter for on_exception!" unless email.class == String
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
          Arask.jobs_touched << job.id
        else
          job = AraskJob.create(job: script, interval: interval, execute_at: interval.seconds.from_now)
          Arask.jobs_touched << job.id
          if run_first_time===true
            job.run
          end
        end
      rescue ActiveRecord::StatementInvalid => e
        puts 'Could not create arask job! Looks like the database is not migrated? Remember to run `rails generate arask:install` and `rails db:migrate`'
      end
    end
  end
end
