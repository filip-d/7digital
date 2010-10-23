module Sevendigital

class ApiOperatorCached < ApiOperator

  def initialize(client, cache)
    @cache = cache
    super(client)
  end

  def call_api(api_request)
    uri = create_request_uri(api_request)
    api_response = @cache.get(uri.to_s) if !api_request.requires_signature?
    puts "ApiOperatorCached: Got from cache #{uri}" if api_response if @client.verbose?
    if (!api_response || response_out_of_date?(api_response)) then
      api_response = make_http_request_and_digest(api_request)
      @cache.set(uri.to_s, api_response) if !api_request.requires_signature?
    end
    puts api_response if @client.very_verbose?    
    api_response
  end

  def response_out_of_date?(api_response)
    response_time = Time.parse(api_response.headers["cache-control"])
    max_age = /max-age=([0-9]*)/.match(api_response.headers["cache-control"])[1].to_i
    response_time + max_age < Time.now
  end

  def response_cacheable?
    return true
  end

end
end
