module Sevendigital

class ApiOperatorCached < ApiOperator

  def initialize(client, cache)
    @cache = cache
    super(client)
  end

  def call_api(api_request)
    uri = create_request_uri(api_request)
    api_response = @cache.get(uri.to_s)
    puts "ApiOperatorCached: Got from cache #{uri}" if api_response if @client.verbose?
    if (!api_response) then
      api_response = make_http_request_and_digest(api_request)
      @cache.set(uri.to_s, api_response)
    end
    puts api_response if @client.very_verbose?    
    api_response
  end
end

end
