require_relative 'lib/chambermaid/version'

Gem::Specification.new do |spec|
  spec.name          = "chambermaid"
  spec.version       = Chambermaid::VERSION
  spec.authors       = ["Miles Zimmerman"]
  spec.email         = ["miles@asktrim.com"]

  spec.summary       = %q{Companion Ruby Gem for chamber cli}
  spec.homepage      = "https://github.com/mileszim/chambermaid"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mileszim/chambermaid"
  spec.metadata["changelog_uri"] = "https://github.com/mileszim/chambermaid/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Gems
  spec.add_dependency("aws-sdk-ssm", "~> 1.85")
  spec.add_development_dependency("rspec", "~> 3.0")
  spec.add_development_dependency("rake", "~> 12.0")
end
