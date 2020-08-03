# Chambermaid [![Gem Version](https://badge.fury.io/rb/chambermaid.svg)](https://badge.fury.io/rb/chambermaid) [![Build Status](https://travis-ci.com/mileszim/chambermaid.svg?branch=master)](https://travis-ci.com/mileszim/chambermaid)

Companion RubyGem for [chamber](https://github.com/segmentio/chamber).

Chambermaid injects AWS SSM params into your ENV. Plays nice with other ENV gems like dotenv.

 - [RubyDocs](https://rubydoc.info/gems/chambermaid)

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
  # Load all values from SSM Namespace path
  config.add_namespace("/my/param/namespace")

  # Load values from chamber-cli service
  config.add_service("my-chamber-service")

  # Set `overload: true` to choose these params over existing
  # ones in ENV when they are merged together
  config.add_namespace("/my/important/namespace", overload: true)
end

# If this is standalone ruby (not a Rails environment),
# call `Chambermaid.load!` after the configuration block
#
# Chambermaid.load!
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

**Configure Logging**
```ruby
Chambermaid.configure do |config|
  # ... other config ...

  # Change log level
  config.log_level = :debug

  # Set custom logger instance
  config.logger = MyCoolLogger.new
end

# Outside of config block
Chambermaid.log_level = :warn
```

_Note: Chambermaid.logger is set to Rails.logger automatically if including inside a rails app_

### AWS Authentication

Chambermaid expects your AWS credential configuration to live inside ENV on application load.

> **Note:** `AWS_DEFAULT_REGION` or `AWS_REGION` is **required**

You can use either:
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

or STS grants:
```bash
$ aws-vault exec my-user -- bundle exec rails server
```
> *See [aws-vault](https://github.com/99designs/aws-vault/blob/master/USAGE.md) docs for more info*

or a metadata endpoint grant:
* Available in attached Task or EC2 instance. *See [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-metadata-endpoint.html) for more info.*
* Through aws-vault: `aws-vault exec -s my-user`

#### IAM Permissions Required

Since this is meant to work out of the box as a complement to [chamber cli](https://github.com/segmentio/chamber), it needs similar IAM permissions.

In this case, however, we can grant read-only to the namespace(s).
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "ssm:DescribeParameters",
            "Resource": "*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:ssm:us-east-1:1234567890:parameter/my-chamber-service",
                "arn:aws:kms:us-east-1:1234567890:key/258574a1-cfce-4530-9e3c-d4b07cd04115"
            ]
        }
    ]
}
```
> **Note:** `Resource` array MUST include the full ARN of the key id used for chamber cli
> *(Default alias is `parameter_store_key`)*


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mileszim/chambermaid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mileszim/chambermaid/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Chambermaid project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mileszim/chambermaid/blob/master/CODE_OF_CONDUCT.md).
