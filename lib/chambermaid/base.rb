require "chambermaid/environment"
require "chambermaid/namespace"
require "chambermaid/parameter_store"

module Chambermaid
  module Base
    def self.extended(base)
      # Make a copy of ENV before we mess it all up
      @@_original_env = ENV.to_h.dup.freeze
    end

    extend self

    def configure
      yield self
      load!
    end

    # @todo
    def configuration
      raise "Namespaces must be defined" unless @namespaces
    end

    # Load SSM into ENV
    def load!
      @namespaces.each(&:load!)
    end

    # @todo
    def reload!
      @namespaces.each(&:reload!)
    end

    def unload!
      @namespaces.each(&:unload!)
    end

    # Restore ENV to its original state
    def restore!
      ENV.replace(@@_original_env)
    end
    alias :reset! :restore!

    # Add an AWS SSM parameter namespace to ENV
    #
    # @param [String] path
    # @param [Boolean] overload
    #   true  - replace any duplicate ENV keys with new params
    #   false - keep any existing duplicate ENV key values
    #
    # @raise [ArgumentError]
    #   when `path` is not a string
    #
    # @example
    #   Chambermaid.add_namespace("/my/param/namespace")
    #
    # @example overload duplicate ENV vars
    #   Chambermaid.add_namespace("/my/param/namespace", overload: true)
    def add_namespace(path, overload: false)
      raise ArgumentError.new("`path` must be a string") unless path.is_a?(String)
      raise ArgumentError.new("`overload` must be a boolean") unless [true, false].include?(overload)

      namespaces << Namespace.new(path: path, overload: overload)
    end

    # Immediately load an AWS SSM parameter namespace to ENV
    #
    # @param [String] path
    # @param [Boolean] overload
    #   true  - replace any duplicate ENV keys with new params
    #   false - keep any existing duplicate ENV key values
    #
    # @raise [ArgumentError]
    #   when `path` is not a string
    #
    # @example
    #   Chambermaid.add_namespace!("/my/param/namespace")
    #
    # @example overload duplicate ENV vars
    #   Chambermaid.add_namespace("/my/param/namespace", overload: true)
    def add_namespace!(path, overload: false)
      raise ArgumentError.new("`path` must be a string") unless path.is_a?(String)
      raise ArgumentError.new("`overload` must be a boolean") unless [true, false].include?(overload)

      namespaces << Namespace.load!(path: path, overload: overload)
    end

    # Add all secrets from Chamber service to ENV
    #
    # @param [String] service
    # @param [Boolean] overload
    #   true  - replace any duplicate ENV keys with new params
    #   false - keep any existing duplicate ENV key values
    #
    # @example
    #   Chambermaid.add_service("my-chamber-service")
    #
    # @example overload duplicate ENV vars
    #   Chambermaid.add_service("my-chamber-service", overload: true)
    #
    # @see {Chambermaid::Base.add_namespace}
    def add_service(service, overload: false)
      service = "/#{service}" unless service[0] == "/"
      add_namespace(service)
    end

    private

    def namespaces
      @namespaces ||= []
    end
  end
end
