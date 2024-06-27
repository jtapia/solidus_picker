# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'securerandom'

module SolidusPicker
  class HttpClient
    def initialize(base_url, config, custom_client_exec = nil)
      @base_url = base_url
      @config = config
      @custom_client_exec = custom_client_exec
    end

    # Execute an HTTP request to the API.
    def request(
      method:,
      path:,
      headers: {},
      body: {}
    )
      # Remove leading slash from path.
      path = path[1..] if path[0] == '/'

      uri = URI.parse("#{@base_url}/#{path}")
      headers = @config[:headers].merge(headers || {})

      response = if @custom_client_exec
                   @custom_client_exec.call(method, uri, headers, body)
                 else
                   default_request_execute(method, uri, headers, body)
                 end
      response_timestamp = Time.now

      response
    end

    def default_request_execute(method, uri, headers = nil, body = nil)
      # Create the request, set the headers and body if necessary.
      request = Net::HTTP.const_get(method.capitalize).new(uri)
      headers.each { |k, v| request[k] = v }
      request.body = body if body

      begin
        # Attempt to make the request and return the response.
        Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: true,
        ) do |http|
          http.request(request)
        end
      rescue Net::ReadTimeout, Net::OpenTimeout, Errno::EHOSTUNREACH => e
        # Raise a timeout error if the request times out.
        raise Picker::Errors::TimeoutError.new(e.message)
      rescue OpenSSL::SSL::SSLError => e
        # Raise an SSL error if the request fails due to an SSL error.
        raise Picker::Errors::SslError.new(e.message)
      rescue StandardError => e
        # Raise an unknown HTTP error if anything else causes the request to fail to complete
        # (this is different from processing 4xx/5xx errors from the API)
        raise Picker::Errors::UnknownApiError.new(e.message)
      end
    end
  end
end
