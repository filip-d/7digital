module Sevendigital

  require 'net/http'
  require 'net/https'
  require 'oauth'
  require 'uri'
  require 'cgi'
  
  class ApiOperator

  def initialize(client)
    @client = client
  end

  def call_api(api_request)
    api_response = make_http_request_and_digest(api_request)
    puts api_response.content.to_s if @client.very_verbose?
    api_response
  end

  def make_http_request_and_digest(api_request)
      digest_http_response(make_http_request(api_request))
  end

  def make_http_request(api_request)

    http_client, http_request = create_http_request(api_request)

    http_client.set_debug_output($stdout) if @client.very_verbose?
    log_request(http_request) if @client.verbose?

    http_client.request(http_request)
  end

  def digest_http_response(http_response)
    api_response = @client.api_response_digestor.from_http_response(http_response)
    raise Sevendigital::SevendigitalError.new(api_response.error_code, api_response.error_message), "#{api_response.error_code} - #{api_response.error_message}" if !api_response.ok?
    api_response
  end

  def create_http_request(api_request)
    if (api_request.requires_signature?) then
      http_client, http_request = create_signed_http_request(api_request)
    else
      http_client, http_request = create_standard_http_request(api_request)
    end
    return http_client, http_request
  end

  def create_signed_http_request(api_request)
    request_uri = create_request_uri(api_request)
    http_client = Net::HTTP.new(request_uri.host, request_uri.port)
    http_request = Net::HTTP::Get.new(request_uri.request_uri)
    http_client.use_ssl = true
    http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
    puts "Prepared request #{request_uri.to_s}" if @client.verbose?
    puts http_request.signature_base_string(http_client, @client.oauth_consumer, api_request.token) if @client.very_verbose?
    http_request.oauth!( \
    http_client, \
      @client.oauth_consumer, \
      api_request.token \
    )
    return http_client, http_request
  end

  def create_standard_http_request(api_request)
    request_uri = create_request_uri(api_request)
    request_uri.query += '&oauth_consumer_key=' + @client.configuration.oauth_consumer_key
    http_client = Net::HTTP.new(request_uri.host, request_uri.port)
    http_request = Net::HTTP::Get.new(request_uri.request_uri)
    return http_client, http_request
  end

  def create_request_uri(api_request)
    api_request.ensure_country_is_set(@client.country)
    host = @client.configuration.api_url
    path = "/#{@client.configuration.api_version}/#{api_request.api_method}"
    query = api_request.parameters.map{ |k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join("&")
    if api_request.requires_signature? then
      URI::HTTPS.build(:host => host, :path => path, :query =>query)
    else
      URI::HTTP.build(:host => host, :path => path, :query =>query)
    end
  end

  def log_request(request)
    puts "ApiOperator: Calling #{request.inspect}"
  end

end

end