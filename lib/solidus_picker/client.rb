# # frozen_string_literal: true

require 'json'
require 'securerandom'

PRODUCTION_URL='https://api.pickerexpress.com/api'
SANDBOX_URL='https://dev-api.pickerexpress.com/api'

module SolidusPicker
  class Client
    attr_reader :api_key,
                :api_base,
                :package,
                :http_client

    # Initialize a new Client object
    # @param api_key [String] the API key to be used for requests
    # @param read_timeout [Integer] (60) the number of seconds to wait for a response before timing out
    # @param open_timeout [Integer] (30) the number of seconds to wait for the connection to open before timing out
    # @param api_base [String] ('https://api.pickerexpress.com') the base URL for the API
    # @param custom_client_exec [Proc] (nil) a custom client execution block to be used for requests instead of the default HTTP client (function signature: method, uri, headers, open_timeout, read_timeout, body = nil)
    # @return [Picker::Client] the client object
    def initialize(api_key:, package: nil, custom_client_exec: nil)
      raise Picker::Errors::MissingParameterError.new('api_key') if api_key.nil?

      @api_key = api_key
      @package = package
      @api_base = SolidusPicker.configuration.production == true ? PRODUCTION_URL : SANDBOX_URL

      # Make an HTTP client once, reuse it for all requests made by this client
      # Configuration is immutable, so this is safe
      # binding.pry
      @http_client = SolidusPicker::HttpClient.new(
        api_base,
        http_config,
        custom_client_exec
      )
    end

    # Make an HTTP request
    #
    # @param method [Symbol] the HTTP Verb (get, method, put, post, etc.)
    # @param endpoint [String] URI path of the resource
    # @param body [Object] (nil) object to be dumped to JSON
    # @raise [Picker::Error] if the response has a non-2xx status code
    # @return [Hash] JSON object parsed from the response body
    def make_request(
      method:,
      endpoint:,
      headers: {},
      body: {}
    )
      response = http_client.request(
        method: method,
        path: endpoint,
        headers: headers,
        body: body
      )

      potential_error = SolidusPicker::Errors::ApiError.handle_api_error(response)
      raise potential_error unless potential_error.nil?

      JSON.parse(response.body)
    end

    private

    def http_config
      http_config = {
        headers: default_headers
      }

      http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
      http_config
    end

    def default_headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => authorization,
      }
    end

    def user_agent
      "Picker/" \
        "OS/#{SolidusPicker::Utilities::System.os_name} " \
        "OSVersion/#{SolidusPicker::Utilities::System.os_version} " \
        "OSArch/#{SolidusPicker::Utilities::System.os_arch}"
    end

    def authorization
      "Bearer #{api_key}"
    end
  end
end
