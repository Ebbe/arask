# Arask
Automatic RAils taSKs (with minimal setup).

The interval starts when the task has started running. If a task with the interval `:hourly` is run at 08:37PM, then it will run the next time at 09:37PM.

## Usage
After installation, you can edit config/initializers/arask.rb with your tasks.

### Examples
```ruby
arask.create script: 'puts "IM ALIVE!"', interval: :daily, run_first_time: true
arask.create script: 'Attachment.process_new', interval: 5.hours if Rails.env.production?
# Run rake task:
arask.create task: 'my:awesome_task', interval: :hourly
```

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

Setup your tasks in config/initializers/arask.rb.

## Todos
* Be able to setup error handling. For instance in initializer: `arask.on_fail email: 'gr34test_dev@example.com'`
* Have a "try again" feature. For instance `arask.create script: 'raise "I failed"', interval: :daily, fail_retry: 5.minutes, retry_at_most: 2`

## Caveats
If you reload a database dump, your jobs could be run again.

## Contributing
Please use https://github.com/Ebbe/arask

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
