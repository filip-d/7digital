module Sevendigital

#@private
#Cached version of ApiOperator
#If response for an API request is already in cache and
#and it hasn't expired returns the cached response is returned instead of making an API call
#otherwise uses methods inherited from ApiOperator to make an HTTP call to the API
class ApiOperatorCached < ApiOperator # :nodoc:

  def initialize(client, cache)
    @cache = cache
    super(client)
  end

  def call_api(api_request)
    request_cache_key = create_request_uri(api_request)
    http_response = @cache.get(request_cache_key.to_s) if !api_request.requires_signature?
    puts "ApiOperatorCached: Got from cache #{request_cache_key}" if @client.verbose? && http_response
    puts "but the response is out of date" if @client.verbose? && http_response && response_out_of_date?(http_response)
    if (!http_response || response_out_of_date?(http_response)) then
      http_response = make_http_request(api_request)
      @cache.set(request_cache_key.to_s, http_response) if !api_request.requires_signature?
    end
    api_response = digest_http_response(http_response)
    p api_response if @client.very_verbose?
    api_response
  end

  def response_out_of_date?(http_response, current_time=nil)
    return true if http_response.header.nil? || http_response.header["Date"].nil? || http_response.header["cache-control"].nil?
    puts "cache headers present"
    return true if  !(http_response.header["cache-control"] =~ /max-age=([0-9]+)/)
    current_time ||= Time.now.utc
    response_time = Time.parse(http_response.header["Date"])
    max_age = /max-age=([0-9]+)/.match(http_response.header["cache-control"])[1].to_i
    response_time + max_age < current_time
  end

end

end
