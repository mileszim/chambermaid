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

    def loaded?
      !@params_list.empty?
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

    private

    def client
      @client ||= Aws::SSM::Client.new
    end

    def fetch_ssm_params!
      Chambermaid.logger.debug("fetching AWS SSM parameters from `#{@path}`")
      @param_list = []
      response = nil
      loop do
        response = fetch_ssm_param_batch!(response&.next_token)
        @param_list.concat(response.parameters)

        if response.next_token
          Chambermaid.logger.debug("response.next_token found, continuing fetch")
        else
          break
        end
      end
      Chambermaid.logger.debug("fetched #{@param_list.size} parameters from `#{@path}`")
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
      @params_list = []
    end
  end
end
