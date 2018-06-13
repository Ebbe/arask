Arask.setup do |arask|
  # Examples
  #arask.create script: 'puts "IM ALIVE!"', interval: :daily, run_first_time: true
  #arask.create script: 'Attachment.process_new', interval: 5.hours if Rails.env.production?
  # Run rake task:
  #arask.create task: 'my:awesome_task', interval: :hourly
  # On exceptions, send email
  #arask.on_exception email: 'errors@example.com'
end
