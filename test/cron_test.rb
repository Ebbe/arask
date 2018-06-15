require 'test_helper'

class Arask::Test < ActiveSupport::TestCase

  test 'can read normal cron syntax' do
    # Stop time (Yes I am God)
    travel_to Time.utc(2000, 4, 5, 10, 0, 5)

    Arask.setup do |arask|
      arask.create script: 'random"', cron: '* * * * *'
    end
    assert(Arask::AraskJob.first.execute_at == Time.utc(2000, 4, 5, 10, 1, 0))

    Arask.setup do |arask|
      arask.create script: 'random"', cron: '0 * * * *'
    end
    assert(Arask::AraskJob.first.execute_at == Time.utc(2000, 4, 5, 11, 0, 0))

    Arask.setup do |arask|
      arask.create script: 'random"', cron: '0 2 * * *'
    end
    assert(Arask::AraskJob.first.execute_at == Time.utc(2000, 4, 6, 2, 0, 0))

    Arask.setup do |arask|
      arask.create script: 'random"', cron: '*/5 * * * *'
    end
    assert(Arask::AraskJob.first.execute_at == Time.utc(2000, 4, 5, 10, 5, 0))
  end
end
