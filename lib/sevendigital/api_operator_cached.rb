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
      api_response = retrieve_from_cache(api_request)
      api_response = cache_response(api_request) if response_out_of_date?(api_response)

      api_response.tap do |api_response|
        @client.log(:verbose) { "ApiOperatorCached: API Response: #{api_response}" }
      end
    end


    def response_out_of_date?(api_response, current_time=nil)
      puts @client.inspect
      (api_response.nil? || header_invalid?(api_response.headers) || cache_expired?(api_response.headers, current_time)).tap do |expired|
        @client.log(:verbose) { "ApiOperatorCached: Cache response out of date" if expired }
      end
    end

  private

    def header_invalid?(header)
      header["Date"].nil? || header["cache-control"].nil? || !(header["cache-control"] =~ /max-age=([0-9]+)/)
    end

    def cache_expired?(header, current_time=nil)
      (Time.parse(header["Date"]) + (/max-age=([0-9]+)/.match(header["cache-control"])[1].to_i)) < (current_time || Time.now.utc)
    end

    def cache_response(api_request)
      digest_http_response(make_http_request(api_request)).tap do |api_response|
        unless api_request.requires_signature?
          key = request_cache_key(api_request)
          @cache.respond_to?(:write) ? @cache.write(key, api_response) : @cache.set(key, api_response)
          @client.log(:verbose) { "ApiOperatorCached: Storing response in cache..." }
        end
      end
    end

    def request_cache_key(api_request)
      create_request_uri(api_request).to_s
    end

    def retrieve_from_cache(api_request)
      unless api_request.requires_signature?
        key = request_cache_key(api_request)
        (@cache.respond_to?(:read) ? @cache.read(key) : @cache.get(key)).tap do |response|
          @client.log(:verbose) { "ApiOperatorCached: Got from cache #{key}" if response }
        end
      end
    end
  end
end
