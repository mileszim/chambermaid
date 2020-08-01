require "chambermaid/parameter_store"

module Chambermaid
  module Base
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
    end

    # Add an AWS SSM parameter namespace to ENV
    #
    # @param [String] path
    # @param [Boolean] overwrite_duplicates
    #   true  - replace any duplicate ENV keys with new params
    #   false - keep any existing duplicate ENV key values
    #
    # @raise
    def add_namespace(path, overwrite_duplicates: false)
      @namespaces ||= {}
      raise "namespace already included in ENV" unless @namespaces[path].nil?

      @namespaces[path] = ParameterStore.load!(path: path)
      update_env!(
        params: @namespaces[path].params,
        overwrite_duplicates: overwrite_duplicates
      )
    end

    # Inject into ENV
    #
    # @param [Hash] params
    # @param [Boolean] overwrite_duplicates
    #   true  - replace any duplicate ENV keys with new params
    #   false - keep any existing duplicate ENV key values
    def update_env!(params:, overwrite_duplicates:)
      if overwrite_duplicates
        ENV.update(params)
      else
        current_env = ENV.to_h.dup
        new_env = params.merge(current_env)
        ENV.replace(new_env)
      end
    end
  end
end
