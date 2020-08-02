require "chambermaid/base"
require "chambermaid/version"
require "chambermaid/railtie" if defined?(Rails)

module Chambermaid
  class Error < StandardError; end

  extend Base
end
