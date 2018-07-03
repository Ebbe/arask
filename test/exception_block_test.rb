require 'test_helper'

class Arask::Test < ActiveSupport::TestCase
  test 'can execute an exception block' do
    old_stdout = $stdout
    $stdout = StringIO.new

    exception_text = nil
    exception_job_text = nil
    Arask.setup do |arask|
      arask.create script: 'puts "no error"', cron: '* * * * *', run_first_time: true
      arask.create script: 'raise "Message!"', cron: '* * * * *', run_first_time: true
      arask.create script: 'puts "no error"', cron: '* * * * *', run_first_time: true
      
      arask.on_exception do |exception, job|
        exception_text = exception.to_s
        exception_job_text = job.job
      end
    end
    Arask::RunJobs.perform_now
    assert(exception_text == "Message!")
    assert(exception_job_text == 'raise "Message!"')

    $stdout = old_stdout
  end
end
