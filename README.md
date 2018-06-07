# Arask
Automatic RAils taSKs.

Beware that these tasks are only run when ActionController has successfully rendered an action. The interval specified is the `least` time that will go since last run.

## Usage
After installation, you can edit config/initializers/arask.rb with your tasks.

# Examples
```ruby
arask.create script: 'puts "IM ALIVE!"', interval: :daily, run_first_time: true
arask.create script: 'Attachment.process_new', interval: 5.hours
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
