require "bundler/setup"
require "chambermaid"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:each) do
    [
      Chambermaid,
      Chambermaid::Base,
      Chambermaid::Environment,
      Chambermaid::Namespace,
      Chambermaid::ParameterStore,
    ].each do |m|
      RSpec::Mocks.space.proxy_for(m).reset
    end
  end
end
