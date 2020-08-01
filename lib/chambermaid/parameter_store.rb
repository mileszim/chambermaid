require "aws-sdk-ssm"

module Chambermaid
  class ParameterStore
    def initialize(path:)
      @path = path
    end

    def load!
      fetch_ssm_params!
    end

    def reload!
      clear_params!
      fetch_ssm_params!
    end

    def self.load!(path:)
      store = new(path: path)
      store.load!
      store
    end

    def params
      @params ||= @param_list.map { |p|
        [p.name.split("/").last.upcase, p.value]
      }.to_h
    end

    alias :to_h :params

    def to_env
      params.inject("") do |env_str, param|
        env_str + "#{param[0]}=#{param[1]}\n"
      end
    end

    private

    def client
      @client ||= Aws::SSM::Client.new
    end

    def fetch_ssm_params!
      @param_list = []
      response = nil
      loop do
        response = fetch_ssm_param_batch!(response&.next_token)
        @param_list.concat(response.parameters)

        break unless response.next_token
      end
    end

    def fetch_ssm_param_batch!(next_token = nil)
      client.get_parameters_by_path(
        path: @path,
        with_decryption: true,
        recursive: true,
        next_token: next_token
      )
    end

    def clear_params!
      @params = nil
      @params_list = nil
    end
  end
end
