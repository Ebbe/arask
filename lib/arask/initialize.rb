Arask.setup do |arask|
  # Examples
  #arask.create script: 'puts "IM ALIVE!"', interval: :daily, run_first_time: true
  #arask.create script: 'Attachment.process_new', interval: 5.hours if Rails.env.production?
  #arask.create task: 'send:logs', cron: '0 2 * * *' # At 02:00 every day
  #arask.create task: 'update:cache', cron: '*/5 * * * *' # Every 5 minutes
  # Run rake task:
  #arask.create task: 'my:awesome_task', interval: :hourly
  # On exceptions, send email
  #arask.on_exception email: 'errors@example.com'
end
