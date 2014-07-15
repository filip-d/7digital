module Sevendigital

  require 'net/http'
  require 'net/https'
  require 'oauth'
  require 'uri'
  require 'cgi'

  #@private
  #internal class used for translating ApiRequests into http calls
  #deals with OAuth signing requests that require signature, making sure parameters are in correct format etc
  class ApiOperator # :nodoc:

    RESERVED_CHARACTERS = /[^a-zA-Z0-9\-\.\_\~]/

    def initialize(client)
      @client = client
    end

    def call_api(api_request)
      make_http_request_and_digest(api_request).tap do |api_response|
        @client.log(:very_verbose) { "ApiOperator: API Response: #{api_response}" }
      end
    end

    def get_request_uri(api_request)
      api_request.signature_scheme = :query_string if api_request.requires_signature?
      http_client, http_request = create_http_request(api_request)
      path = http_request.instance_variable_get("@path")
      host = http_client.instance_variable_get("@address")
      port = http_client.instance_variable_get("@port")
      scheme = port == 443 ? "https" : "http"
      "#{scheme}://#{host}#{path}"
    end

    def make_http_request_and_digest(api_request)
      digest_http_response(make_http_request(api_request))
    end

    def make_http_request(api_request)
      http_client, http_request = create_http_request(api_request)
      @client.log(:verbose) { "ApiOperator: Making HTTP Request..." }
      http_client.request(http_request).tap do |http_response|
        @client.log(:very_verbose) { "ApiOperator: Response Headers: #{http_response.header.to_yaml}" }
      end
    end

    def digest_http_response(http_response)
      @client.api_response_digestor.from_http_response(http_response).tap do |api_response|
        unless api_response.ok?
          raise Sevendigital::SevendigitalError.new(api_response.error_code, api_response.error_message), "#{api_response.error_code} - #{api_response.error_message}"
        end
      end
    end

    def create_http_request(api_request)
      http_client, http_request = create_standard_http_request(api_request)
      if (api_request.requires_signature?)
        oauth_sign_request(http_client, http_request, api_request)
      else
      end
      [http_client, http_request]
    end

    def oauth_sign_request(http_client, http_request, api_request)
      http_request.oauth!( \
      http_client, \
        @client.oauth_consumer, \
        api_request.token, \
        {:scheme => api_request.signature_scheme}
      )
      http_request
    end

    def create_standard_http_request(api_request)
      request_uri = create_request_uri(api_request)
      http_client = Net::HTTP.new(request_uri.host, request_uri.port)

      if !api_request.requires_signature?
        request_uri.query ||= ""
        request_uri.query += "&oauth_consumer_key=#{@client.configuration.oauth_consumer_key}"
      end

      http_request = new_http_request(request_uri.request_uri, api_request.http_method)

      ensure_secure_connection(http_client) if api_request.requires_secure_connection?
      add_form_parameters(http_request, api_request)

      @client.log(:verbose) { "ApiOperator: Creating HTTP Request: #{request_uri}" }

      [http_client, http_request]
    end

    def ensure_secure_connection(http_client)
      http_client.use_ssl     = true
      http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def create_request_uri(api_request)
      host, version = @client.api_host_and_version(api_request.api_service)
      path = (version.to_s.strip.empty? ? "" : "/#{version}") + "/#{api_request.api_method}"
      query = api_request.parameters.map{ |k,v| "#{escape(k)}=#{escape(v)}" }.join("&")
      query = nil if query == ""
      if api_request.requires_secure_connection? then
        URI::HTTPS.build(:host => host, :path => path, :query =>query)
      else
        URI::HTTP.build(:host => host, :path => path, :query =>query)
      end
    end

    def new_http_request(request_uri, http_method)
      request_type = Kernel.const_get("Net").const_get("HTTP").const_get(http_method.to_s.capitalize)
      request_type.new(request_uri, {"user-agent" => @client.user_agent_info})
    end

    def add_form_parameters(http_request, api_request)
      http_request.body = api_request.form_parameters.map {|k, v| "#{escape(k)}=#{escape(v)}" }.flatten.join('&')
      http_request.content_type = 'application/x-www-form-urlencoded'
    end

    def escape(value)
      URI::escape(value.to_s, RESERVED_CHARACTERS)
    rescue ArgumentError
      URI::escape(value.to_s.force_encoding(Encoding::UTF_8), RESERVED_CHARACTERS)
    end
  end
end
