module Sevendigital

  require 'net/http'
  
  class ApiOperator

  def initialize(client)
    @client = client
  end

  def call_api(api_request)
    api_request.ensure_country_is_set(@client.country)
    uri = create_request_uri(api_request)
    http_response = Net::HTTP.get_response(uri)
    return @client.api_response_digestor.from_http_response(http_response)
  end

  def call_api_cached(api_request)

    cache = @client.configuration.cache

    api_request.ensure_country_is_set(@client.country)
    uri = create_request_uri(api_request)

    http_response = cache.get(uri.to_s) if cache

    if (!http_response) then
      puts "API Operator calling #{uri.to_s}"
      http_response = Net::HTTP.get_response(uri)
      if (http_response.kind_of? Net::HTTPSuccess) then
        cache.set(uri.to_s, http_response) if cache
      end
    else
      puts "API Operator got from cache #{uri.to_s}"      
    end

  #  puts http_response
    
    return @client.api_response_digestor.from_http_response(http_response)
  end

  def create_request_uri(api_request)
    params = api_request.parameters.collect{ |a,v| "&#{a}=#{v}" }.join
    URI.parse("http://#{@client.configuration.api_url}/#{@client.configuration.api_version}/#{api_request.api_method}"+
              "?oauth_consumer_key=#{@client.configuration.oauth_consumer_key}#{params}")
  end

end

end