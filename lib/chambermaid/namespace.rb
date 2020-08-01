module Chambermaid
  class Namespace
    # @param [String] path
    # @param [Boolean] overload
    def initialize(path:, overload: false)
      @path = path
      @overload = overload
      @store = ParameterStore.new(path: path)
    end

    def self.load!(path:, overload:)
      namespace = new(path: path, overload: overload)
      namespace.load_env!
      namespace
    end

    # Inject into ENV
    def load_env!
      load_store! unless @store.loaded?
      @overload ? @store.env.overload! : @store.env.load!
    end

    def reload_env!
      @store.reload!
      load_env!
    end

    def load_store!
      @store.load!
    end
  end
end
