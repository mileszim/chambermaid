module Chambermaid
  class Environment
    attr_reader :params

    # Create new Chambermaid::Environment
    #
    # @param [Hash] params
    #
    # @return [Chambermaid::Environment]
    def initialize(params)
      raise ArgumentError.new("params must be hash") unless params.respond_to?(:to_h)
      @params = format_env(params.to_h.dup).freeze
    end

    # Generate a dotenv (.env) compatible string
    #
    # @return [String] dotenv compatible string
    def to_dotenv
      @params.inject("") do |env_str, param|
        env_str + "#{param[0]}=#{param[1]}\n"
      end
    end

    # Write a .env file
    #
    # @param [String] file_path
    def to_file!(file_path)
      File.open(file_path, "wb") do |f|
        f.write(to_dotenv)
      end
    end

    # @alias {#params}
    #
    # @return [Hash]
    def to_h
      @params
    end

    # Inject into ENV without overwriting duplicates
    def load!
      current_env = ENV.to_h.dup
      new_env = @params.dup.merge(current_env)
      ENV.replace(new_env)
    end

    # Inject into ENV and overwrite duplicates
    def overload!
      ENV.update(@params)
    end

    private

    def format_env(params)
      params.map{|k,v| [k.upcase, v]}.to_h
    end
  end
end
