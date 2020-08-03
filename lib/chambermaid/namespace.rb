module Chambermaid
  # Namespaces each contain a ParameterStore and Environment instance,
  # along with the overload flag
  class Namespace
    # @param [String] path
    # @param [Boolean] overload
    def initialize(path:, overload: false)
      @path = path
      @overload = overload

      @store = ParameterStore.new(path: path)
      @env = Environment.new({})
    end

    # Create a namespace and immediately fetch and inject params to ENV
    #
    # @see Chambermaid::Namespace.load!
    #
    # @param [String] path
    # @param [Boolean] overload
    #
    # @return [Chambermaid::Namespace]
    def self.load!(path:, overload: false)
      namespace = new(path: path, overload: overload)
      namespace.load!
      namespace
    end

    # Load ParameterStore and inject into ENV
    #
    # @see Chambermaid::ParameterStore#load!
    # @see Chambermaid::Environment#load!
    # @see Chambermaid::Environment#overload!
    def load!
      @store.load!
      load_env!
    end

    # Unload params from ENV, reload ParameterStore, and inject into ENV
    #
    # @see Chambermaid::Environment#unload!
    # @see Chambermaid::ParameterStore#reload!
    # @see Chambermaid::Environment#load!
    # @see Chambermaid::Environment#overload!
    def reload!
      @env.unload!
      @store.reload!
      load_env!
    end

    # Unload params from ENV
    #
    # @see Chambermaid::Environment#unload!
    def unload!
      @env.unload!
      Chambermaid.logger.info("unloaded #{@env.size} params from ENV")
    end

    private

    # Inject into ENV
    def load_env!
      @env.replace(@store.params)
      @overload ? @env.overload! : @env.load!
      Chambermaid.logger.info("loaded #{@env.size} params into ENV from `#{@path}`")
    end
  end
end
