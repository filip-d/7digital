module Sevendigital

  require 'net/http'
  require 'oauth'
  
  class ApiOperatorSecure

  def initialize(client)
    @client = client
  end

  def call_api(api_request)
    api_response = make_http_request_and_digest(create_request_uri(api_request))
    puts api_response if @client.very_verbose?
    api_response
  end

  def make_http_request_and_digest(uri)
    puts "ApiOperator: Calling #{uri}" if @client.verbose?
    http_response = Net::HTTP.get_response(uri)
    api_response = @client.api_response_digestor.from_http_response(http_response)
    raise Sevendigital::SevendigitalError, "#{api_response.error_code} - #{api_response.error_message}" if !api_response.ok?
    api_response
  end

  def create_request_uri(api_request)
    api_request.ensure_country_is_set(@client.country)
    params = api_request.parameters.collect{ |a,v| "&#{a}=#{v}" }.join
    URI.parse("http://#{@client.configuration.api_url}/#{@client.configuration.api_version}/#{api_request.api_method}"+
              "?oauth_consumer_key=#{@client.configuration.oauth_consumer_key}#{params}")
  end

end

end