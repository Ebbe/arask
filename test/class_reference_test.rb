require 'test_helper'

class ClassReferenceTest < ApplicationJob
  def perform(*args)
    return :i_ran2
  end
end

class Arask::Test < ActiveSupport::TestCase
  test 'can reference class instead of string' do
    Arask.setup do |arask|
      arask.create job: ClassReferenceTest, cron: '* * * * *', run_first_time: true
    end
    assert(Arask::AraskJob.first.run == :i_ran2)
  end
end
