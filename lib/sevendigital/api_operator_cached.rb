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
      if !api_request.requires_signature?
        http_response = @cache.respond_to?(:read) ? @cache.read(request_cache_key.to_s) : @cache.get(request_cache_key.to_s)
      end
      puts "ApiOperatorCached: Got from cache #{request_cache_key}" if @client.verbose? && http_response
      puts "but the response is out of date" if @client.verbose? && http_response && response_out_of_date?(http_response)
      if (!http_response || response_out_of_date?(http_response)) then
        http_response = make_http_request(api_request)
        if !api_request.requires_signature?
          @cache.respond_to?(:write) ? @cache.write(request_cache_key.to_s, http_response) : @cache.set(request_cache_key.to_s, http_response)
        end
      end
      api_response = digest_http_response(http_response)
      p api_response if @client.very_verbose?
      api_response
    end

    def response_out_of_date?(http_response, current_time=nil)
      header_invalid?(http_response.header) || cache_expired?(http_response.header, current_time)
    end

  private

    def header_invalid?(header)
      header.nil? || header["Date"].nil? || header["cache-control"].nil? || !(header["cache-control"] =~ /max-age=([0-9]+)/)
    end

    def cache_expired?(header, current_time=nil)
      (Time.parse(header["Date"]) + (/max-age=([0-9]+)/.match(header["cache-control"])[1].to_i)) < (current_time || Time.now.utc)
    end
  end
end
