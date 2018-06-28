Arask.setup do |arask|
  ## Examples

  # Rake tasks with cron syntax
  #arask.create task: 'send:logs', cron: '0 2 * * *' # At 02:00 every day
  #arask.create task: 'update:cache', cron: '*/5 * * * *' # Every 5 minutes

  # Scripts with interval (when time of day or month etc doesn't matter)
  #arask.create script: 'puts "IM ALIVE!"', interval: :daily
  #arask.create task: 'my:awesome_task', interval: :hourly
  #arask.create task: 'my:awesome_task', interval: 3.minutes

  # Run an ActiveJob.
  #arask.create job: 'ImportCurrenciesJob', interval: 1.month

  # Only run on production
  #arask.create script: 'Attachment.process_new', interval: 5.hours if Rails.env.production?

  # Run first time. If the job didn't exist already when starting rails, run it:
  #arask.create script: 'Attachment.process_new', interval: 5.hours, run_first_time: true

  # On exceptions, send email with details
  #arask.on_exception email: 'errors@example.com'
end
