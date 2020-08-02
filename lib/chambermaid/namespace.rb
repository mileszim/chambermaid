module Chambermaid
  class Namespace
    # @param [String] path
    # @param [Boolean] overload
    def initialize(path:, overload: false)
      @path = path
      @overload = overload

      @store = ParameterStore.new(path: path)
      @env = Environment.new({})
    end

    def self.load!(path:, overload: false)
      namespace = new(path: path, overload: overload)
      namespace.load!
      namespace
    end

    def load!
      @store.load!
      load_env!
    end

    def reload!
      @env.unload!
      @store.reload!
      load_env!
    end

    def unload!
      @env.unload!
    end

    private

    # Inject into ENV
    def load_env!
      @env.replace(@store.params)
      @overload ? @env.overload! : @env.load!
    end
  end
end
