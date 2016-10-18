# GemMonitor ![alt text](https://travis-ci.org/rubene/gem_monitor.png?branch=master "")

Crosscheck projects gem versions against rubygems.org latest versions and creates a report.

## Installation

Add this line to your application's Gemfile:

```
group :development
  gem 'gem_monitor'
end
```

And then execute:

    $ bundle install

Initialize the `gem_monitor` directory with:

    rails generate gem_monitor:install

## Usage

run:

    bin/rake gem_monitor:run

open up gem_monitor/index.html in your browser and check out what gems are outdated.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gem_monitor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
