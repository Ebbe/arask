Arask.setup do |arask|
  arask.create script: 'puts "IM ALIVE!"', interval: :daily, run_first_time: true
end
