# Arask

[![Gem Version](https://badge.fury.io/rb/arask.svg)](https://badge.fury.io/rb/arask)
[![Build Status](https://travis-ci.org/Ebbe/arask.svg?branch=master)](https://travis-ci.org/Ebbe/arask)
[![Coverage Status](https://coveralls.io/repos/github/Ebbe/arask/badge.svg?branch=master)](https://coveralls.io/github/Ebbe/arask?branch=master)

Automatic RAils taSKs (with minimal setup).

No need to setup anything outside of Rails. If Rails is running, so is Arask. If Rails has been stopped, the next time rails starts, Arask will go through overdue jobs and perform them.

Use cron syntax or simply define the interval.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arask'
```

Execute:

```bash
$ bundle install
$ rails generate arask:install
$ rails db:migrate
```

Setup your tasks in config/initializers/arask.rb. Initially it looks [like this](lib/arask/initialize.rb).

## Usage

After installation, you can edit config/initializers/arask.rb with your tasks.

### Examples of jobs in the initializer

```ruby
# Rake tasks with cron syntax
arask.create task: 'send:logs', cron: '0 2 * * *' # At 02:00 every day
arask.create task: 'update:cache', cron: '*/5 * * * *' # Every 5 minutes

# Scripts with interval (when time of day or month etc doesn't matter)
arask.create script: 'puts "IM ALIVE!"', interval: :daily
arask.create task: 'my:awesome_task', interval: :hourly
arask.create task: 'my:awesome_task', interval: 3.minutes

# Run an ActiveJob.
arask.create job: 'ImportCurrenciesJob', interval: 1.month

# Only run on production
arask.create script: 'Attachment.process_new', interval: 5.hours if Rails.env.production?

# Run first time. If the job didn't exist already when starting rails, run it:
arask.create script: 'Attachment.process_new', interval: 5.hours, run_first_time: true

# On exceptions, send email with details
arask.on_exception email: 'errors@example.com'

# Run code on exceptions
arask.on_exception do |exception, arask_job|
  MyExceptionHandler.new(exception)
end
```

### About cron

Arask uses [fugit](https://github.com/floraison/fugit) to parse cron and get next execution time. It follows normal cron syntax. You can test your cron at https://crontab.guru/.

Not supported is `@reboot`.

### About interval

The interval starts when the task has started running. If a task with the interval `:hourly` is run at 08:37PM, then it will run the next time at 09:37PM.

## Todos

- Have a "try again" feature. For instance `arask.create script: 'raise "I failed"', interval: :daily, fail_retry: 5.minutes, retry_at_most: 2`
- Be able to specify line and number that failed for an exception:

```ruby
file,line,_ = caller.first.split(':')
fileline = File.readlines(file)[line.to_i - 1].strip
```

## Special environments

### Heroku

Nothing special to setup. But if you use a hobby dyno and it falls to sleep, so will Arask. As soon as the dyno wakes up, Arask will run any pending jobs.

### Docker

Nothing special to setup.

## Caveats

If you reload a database dump, your jobs could be run again.

## Contributing

Please use https://github.com/Ebbe/arask

## Running tests

```bash
$ bundle install
$ bundle exec rake test
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
