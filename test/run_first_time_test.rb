require 'test_helper'

class Arask::Test < ActiveSupport::TestCase

  test 'arask honours run_first_time' do
    # Stop time (Yes I am God)
    travel_to Date.today.noon

    Arask.setup(true) do |arask|
      arask.create script: 'random', cron: '0 0 1 1 1', run_first_time: true
    end
    assert(Arask::AraskJob.first.execute_at == Time.now)

  end
end
