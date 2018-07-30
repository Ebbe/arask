require 'test_helper'

class ImportCurrenciesJob < ApplicationJob
  def perform(*args)
    return :i_ran
  end
end

class Arask::Test < ActiveSupport::TestCase
  test 'can execute ActiveJob' do
    Arask.setup(true) do |arask|
      arask.create job: 'ImportCurrenciesJob', cron: '* * * * *', run_first_time: true
    end
    assert(Arask::AraskJob.first.run == :i_ran)
  end
end
