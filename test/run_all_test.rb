require 'test_helper'

class Arask::Test < ActiveSupport::TestCase
  test 'actually runs all jobs' do
    # Stop time (Yes I am God)
    travel_to Time.utc(2000, 4, 5, 10, 0, 5)

    Arask.setup(true) do |arask|
      arask.create script: '1+1', cron: '* * * * *'
      arask.create script: '1+2', cron: '* * * * *'
    end
    assert(Arask::AraskJob.first.execute_at == Time.utc(2000, 4, 5, 10, 1, 0))
    # Don't traverse time. Nothing should happen
    Arask::RunJobs.perform_now
    assert(Arask::AraskJob.first.execute_at == Time.utc(2000, 4, 5, 10, 1, 0))

    travel 1.minute
    Arask::RunJobs.perform_now
    assert(Arask::AraskJob.first.execute_at == Time.utc(2000, 4, 5, 10, 2, 0))
  end
end
