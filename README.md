# Chambermaid

Companion RubyGem for [chamber](https://github.com/segmentio/chamber).

Chambermaid injects AWS SSM params into your ENV. Plays nice with other ENV gems like dotenv.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chambermaid'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install chambermaid

## Usage

**Standalone**

```ruby
Chambermaid.add_namespace("/my/param/namespace")
Chambermaid.add_service("my-chamber-service")
```

**Configuration Block**

```ruby
# config/initializers/chambermaid.rb

Chambermaid.configure do |config|
  config.add_namespace("/my/param/namespace")
  config.add_service("my-chamber-service")

  # Set `overload: true` to choose these params over existing
  # ones in ENV when they are merged together
  config.add_namespace("/my/important/namespace", overload: true)
end
```

**Reload SSM into ENV**
```ruby
Chambermaid.reload!
```

**Restore ENV to original state**
```ruby
Chambermaid.restore!
Chambermaid.reset! # alias of .restore!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mileszim/chambermaid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mileszim/chambermaid/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Chambermaid project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mileszim/chambermaid/blob/master/CODE_OF_CONDUCT.md).
