module Chambermaid
  class Environment < Hash
    attr_reader :params

    # Create new Chambermaid::Environment
    #
    # @param [Hash] params
    #
    # @raise [ArgumentError]
    #   if params is not type Hash
    #
    # @return [Chambermaid::Environment]
    def initialize(params)
      validate_params!(params)
      stash_current_env!
      update(format_env(params))
    end

    # Generate a dotenv (.env) compatible string
    #
    # @return [String] dotenv compatible string
    def to_dotenv
      to_h.inject("") do |env_str, param|
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

    # Inject into ENV without overwriting duplicates
    def load!
      each { |k, v| ENV[k] ||= v }
    end

    # Inject into ENV and overwrite duplicates
    def overload!
      each { |k, v| ENV[k] = v }
    end

    # Restore to original ENV
    def unload!
      ENV.replace(@_original_env)
    end

    private

    def stash_current_env!
      @_original_env ||= ENV.to_h.dup.freeze
    end

    def format_env(params)
      params.map{|k,v| [k.upcase, v]}.to_h
    end

    def validate_params!(params)
      unless params.is_a?(Hash)
        raise ArgumentError.new("`params` must be a hash")
      end
    end
  end
end
