module Sevendigital

class ApiOperatorCached < ApiOperator

  def initialize(client, cache)
    @cache = cache
    super(client)
  end

  def call_api(api_request)
    uri = create_request_uri(api_request)
    api_response = @cache.get(uri.to_s) if !api_request.requires_signature?
    puts "ApiOperatorCached: Got from cache #{uri}" if @client.verbose? && api_response
    puts "but the response is out of date" if @client.verbose? && api_response.out_of_date?
    if (!api_response || api_response.out_of_date?) then
      api_response = make_http_request_and_digest(api_request)
      @cache.set(uri.to_s, api_response) if !api_request.requires_signature?
    end
    p api_response if @client.very_verbose?
    api_response
  end

end

end
