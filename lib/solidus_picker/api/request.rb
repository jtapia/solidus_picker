# # frozen_string_literal: true

# module SolidusPicker
#   module Api
#     class Request
#       API_BASE = 'https://ssapi.picker.com'

#       # attr_reader :username, :password

#       # class << self
#       #   def from_config
#       #     new(
#       #       username: SolidusPicker.config.api_key,
#       #       password: SolidusPicker.config.api_secret,
#       #     )
#       #   end
#       end

#       # def initialize(username:, password:)
#       #   @username = username
#       #   @password = password
#       # end

#       def call(method, path, params = {})
#         response = HTTParty.send(
#           method,
#           URI.join(API_BASE, path),
#           body: params.to_json,
#           basic_auth: {
#             username: @username,
#             password: @password,
#           },
#           headers: {
#             'Content-Type' => 'application/json',
#             'Accept' => 'application/json',
#           },
#         )

#         case response.code.to_s
#         when /2\d{2}/
#           response.parsed_response
#         when '429'
#           raise RateLimitedError.from_response(response)
#         else
#           raise RequestError.from_response(response)
#         end
#       end
#     end
#   end
# end


# frozen_string_literal: true

require_relative 'services'
require_relative 'http_client'
require_relative 'internal_utilities'
require 'json'
require 'securerandom'

PRODUCTION_URL='https://dashboard.pickerexpress.com/'
SANDBOX_URL='https://dev-dashboard.pickerexpress.com/'

module SolidusPicker
  module Api
    class Client
      attr_reader :open_timeout, :read_timeout, :api_base

      # Initialize a new Client object
      # @param api_key [String] the API key to be used for requests
      # @param read_timeout [Integer] (60) the number of seconds to wait for a response before timing out
      # @param open_timeout [Integer] (30) the number of seconds to wait for the connection to open before timing out
      # @param api_base [String] ('https://api.pickerexpress.com') the base URL for the API
      # @param custom_client_exec [Proc] (nil) a custom client execution block to be used for requests instead of the default HTTP client (function signature: method, uri, headers, open_timeout, read_timeout, body = nil)
      # @return [Picker::Client] the client object
      def initialize(api_key:, read_timeout: 60, open_timeout: 30, api_base: 'https://dev-api.pickerexpress.com',
                     custom_client_exec: nil)
        raise Picker::Errors::MissingParameterError.new('api_key') if api_key.nil?

        @api_key = api_key
        @api_base = api_base
        @api_version = 'v2'
        @read_timeout = read_timeout
        @open_timeout = open_timeout
        @lib_version = File.open(File.expand_path('../../VERSION', __dir__)).read.strip

        # Make an HTTP client once, reuse it for all requests made by this client
        # Configuration is immutable, so this is safe
        @http_client = Picker::HttpClient.new(api_base, http_config, custom_client_exec)
      end

      # SERVICE_CLASSES = [
      #   Picker::Services::Address,
      #   Picker::Services::ApiKey,
      #   Picker::Services::Batch,
      #   Picker::Services::BetaRate,
      #   Picker::Services::BetaReferralCustomer,
      #   Picker::Services::Billing,
      #   Picker::Services::CarrierAccount,
      #   Picker::Services::CarrierMetadata,
      #   Picker::Services::CarrierType,
      #   Picker::Services::CustomsInfo,
      #   Picker::Services::CustomsItem,
      #   Picker::Services::EndShipper,
      #   Picker::Services::Event,
      #   Picker::Services::Insurance,
      #   Picker::Services::Order,
      #   Picker::Services::Parcel,
      #   Picker::Services::Pickup,
      #   Picker::Services::Rate,
      #   Picker::Services::ReferralCustomer,
      #   Picker::Services::Refund,
      #   Picker::Services::Report,
      #   Picker::Services::ScanForm,
      #   Picker::Services::Shipment,
      #   Picker::Services::Tracker,
      #   Picker::Services::User,
      #   Picker::Services::Webhook,
      # ].freeze

      # Loop over the SERVICE_CLASSES to automatically define the method and instance variable instead of manually define it
      # SERVICE_CLASSES.each do |cls|
      #   define_method(Picker::InternalUtilities.to_snake_case(cls.name.split('::').last)) do
      #     instance_variable_set("@#{Picker::InternalUtilities.to_snake_case(cls.name.split('::').last)}", cls.new(self))
      #   end
      # end

      # Make an HTTP request
      #
      # @param method [Symbol] the HTTP Verb (get, method, put, post, etc.)
      # @param endpoint [String] URI path of the resource
      # @param body [Object] (nil) object to be dumped to JSON
      # @param api_version [String] the version of API to hit
      # @raise [Picker::Error] if the response has a non-2xx status code
      # @return [Hash] JSON object parsed from the response body
      def make_request(
        method,
        endpoint,
        body = nil,
        api_version = Picker::InternalUtilities::Constants::API_VERSION
      )
        response = @http_client.request(method, endpoint, nil, body, api_version)

        potential_error = Picker::Errors::ApiError.handle_api_error(response)
        raise potential_error unless potential_error.nil?

        Picker::InternalUtilities::Json.parse_json(response.body)
      end

      # # Subscribe a request hook
      # #
      # # @param name [Symbol] the name of the hook. Defaults ot a ranom hexadecimal-based symbol
      # # @param block [Block] a code block that will be executed before a request is made
      # # @return [Symbol] the name of the request hook
      # def subscribe_request_hook(name = SecureRandom.hex.to_sym, &block)
      #   Picker::Hooks.subscribe(:request, name, block)
      # end

      # # Unsubscribe a request hook
      # #
      # # @param name [Symbol] the name of the hook
      # # @return [Block] the hook code block
      # def unsubscribe_request_hook(name)
      #   Picker::Hooks.unsubscribe(:request, name)
      # end

      # # Unsubscribe all request hooks
      # #
      # # @return [Hash] a hash containing all request hook subscriptions
      # def unsubscribe_all_request_hooks
      #   Picker::Hooks.unsubscribe_all(:request)
      # end

      # # Subscribe a response hook
      # #
      # # @param name [Symbol] the name of the hook. Defaults ot a ranom hexadecimal-based symbol
      # # @param block [Block] a code block that will be executed upon receiving the response from a request
      # # @return [Symbol] the name of the response hook
      # def subscribe_response_hook(name = SecureRandom.hex.to_sym, &block)
      #   Picker::Hooks.subscribe(:response, name, block)
      # end

      # # Unsubscribe a response hook
      # #
      # # @param name [Symbol] the name of the hook
      # # @return [Block] the hook code block
      # def unsubscribe_response_hook(name)
      #   Picker::Hooks.unsubscribe(:response, name)
      # end

      # # Unsubscribe all response hooks
      # #
      # # @return [Hash] a hash containing all response hook subscriptions
      # def unsubscribe_all_response_hooks
      #   Picker::Hooks.unsubscribe_all(:response)
      # end

      private

      def http_config
        http_config = {
          read_timeout: @read_timeout,
          open_timeout: @open_timeout,
          headers: default_headers,
        }

        http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
        http_config
      end

      def default_headers
        {
          'Content-Type' => 'application/json',
          'User-Agent' => user_agent,
          'Authorization' => authorization,
        }
      end

      def user_agent
        ruby_version = Picker::InternalUtilities::System.ruby_version
        ruby_patchlevel = Picker::InternalUtilities::System.ruby_patchlevel

        "EasyPost/#{@api_version} " \
          "RubyClient/#{@lib_version} " \
          "Ruby/#{ruby_version}-p#{ruby_patchlevel} " \
          "OS/#{Picker::InternalUtilities::System.os_name} " \
          "OSVersion/#{Picker::InternalUtilities::System.os_version} " \
          "OSArch/#{Picker::InternalUtilities::System.os_arch}"
      end

      def authorization
        "Bearer #{@api_key}"
      end
    end
  end
end
