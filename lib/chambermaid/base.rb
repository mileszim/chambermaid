require "chambermaid/parameter_store"

module Chambermaid
  module Base
    def self.extended(base)
      # Make a copy of ENV before we mess it all up
      @@_original_env = ENV.to_h.dup
    end

    extend self

    def configure
      yield self
    end

    # @todo
    def configuration
      raise "Namespaces must be defined" unless @namespaces
    end

    # @todo
    def reload!
      restore!
      @namespaces.each do |ns|
        ns[:store].reload!
        update_env!(
          params: ns[:store].params,
          overload: ns[:overload]
        )
      end
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
    # @raise
    def add_namespace(path, overload: false)
      @namespaces ||= []
      # raise "namespace already included in ENV" unless @namespaces[path].nil?

      store = ParameterStore.load!(path: path)
      @namespaces << { store: store, overload: overload }
      update_env!(params: store.params, overload: overload)
    end

    # Inject into ENV
    #
    # @param [Hash] params
    # @param [Boolean] overload
    #   true  - replace any duplicate ENV keys with new params
    #   false - keep any existing duplicate ENV key values
    def update_env!(params:, overload:)
      if overload
        ENV.update(params)
      else
        current_env = ENV.to_h.dup
        new_env = params.merge(current_env)
        ENV.replace(new_env)
      end
    end
  end
end
