# Arask
Automatic RAils taSKs (with minimal setup).

No need to setup anything outside of Rails. If Rails is running, so is Arask. If Rails has been stopped, the next time rails starts, Arask will go through overdue jobs and perform them.

Use cron syntax or simply define the interval.

## Usage
After installation, you can edit config/initializers/arask.rb with your tasks.

### Examples of jobs in the initializer
```ruby
arask.create script: 'puts "IM ALIVE!"', interval: :daily, run_first_time: true
arask.create script: 'Attachment.process_new', interval: 5.hours if Rails.env.production?
arask.create task: 'send:logs', cron: '0 2 * * *' # At 02:00 every day
arask.create task: 'update:cache', cron: '*/5 * * * *' # Every 5 minutes
# Run rake task:
arask.create task: 'my:awesome_task', interval: :hourly
# On exceptions, send email
arask.on_exception email: 'errors@example.com'
```

### About cron
Arask uses [fugit](https://github.com/floraison/fugit) to parse cron and get next execution time. It follows normal cron syntax. You can test your cron at https://crontab.guru/.

Not supported is `@reboot`.

### About interval
The interval starts when the task has started running. If a task with the interval `:hourly` is run at 08:37PM, then it will run the next time at 09:37PM.

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

## Todos
* Have a "try again" feature. For instance `arask.create script: 'raise "I failed"', interval: :daily, fail_retry: 5.minutes, retry_at_most: 2`
* Tests

## Setup for Heroku
None. But if you use a hobby dyno and it falls to sleep, so will Arask. As soon as the dyno wakes up, Arask will run any pending jobs.

## Caveats
If you reload a database dump, your jobs could be run again.

## Contributing
Please use https://github.com/Ebbe/arask

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
