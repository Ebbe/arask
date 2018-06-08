# Arask
Automatic RAils taSKs.

Beware that these tasks are only run when ActionController has successfully rendered an action. The interval specified is the _least_ time that will go since last run. If no one visits your rails server, no tasks will run. For many tasks this is fine.

The interval starts when the task has started running. A task with the interval :hourly is run at 08:37PM, then it will run the next time ActionController has rendered an action after 09:37PM.

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

And then execute:
```bash
$ bundle
```

Then install the initializer template and migration:
```bash
$ rails generate arask:install
```

Setup your tasks in config/initializers/arask.rb.

## Contributing
Please use https://github.com/Ebbe/arask

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
