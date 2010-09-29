module Sevendigital

  require 'net/http'
  
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
    http_client = Net::HTTP.new(@client.configuration.api_url, 80)
    http_request = Net::HTTP::Get.new(create_request_query(api_request))

    http_request.oauth!( \
      http_client, \
      OAuth::Consumer.new( @client.configuration.oauth_consumer_key, @client.configuration.oauth_consumer_secret), \
      api_request.token \
    )
    log_request(http_request) if @client.verbose?
    http_client.request(http_request)
  end

  def digest_http_response(http_response)
    api_response = @client.api_response_digestor.from_http_response(http_response)
    raise Sevendigital::SevendigitalError, "#{api_response.error_code} - #{api_response.error_message}" if !api_response.ok?
    api_response
  end

  def create_request_query(api_request)
    api_request.ensure_country_is_set(@client.country)
    query = "/#{@client.configuration.api_version}/#{api_request.api_method}?" + api_request.parameters.map{ |k,v| "#{k}=#{v}" }.join("&") 
    query
  end

  def log_request(request)
    puts "ApiOperator: Calling #{query}"
  end

end

end