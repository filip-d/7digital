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
      http_response = retrieve_from_cache(api_request)
      http_response = cache_response(api_request) if response_out_of_date?(http_response)

      digest_http_response(http_response).tap do |api_response|
        @client.log(:verbose) { "ApiOperatorCached: API Response: #{api_response}" }
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
      make_http_request(api_request).tap do |response|
        # Enforce configuration option to cache for a time period.
        unless @client.configuration.default_cache_period.blank?
          if header_invalid?(response.header)
            response.header['cache-control'] = "private, max-age=#{@client.configuration.default_cache_period.to_i}"
            @client.log(:verbose) { "ApiOperatorCached: Updating cache-control header with: #{@client.configuration.default_cache_period.to_i} seconds" }
          end
        end

        unless api_request.requires_signature?
          key = request_cache_key(api_request)
          @cache.respond_to?(:write) ? @cache.write(key, response) : @cache.set(key, response)
          @client.log(:verbose) { "ApiOperatorCached: Storing response in cache..." }
        end
      end
    end

    def request_cache_key(api_request)
      create_request_uri(api_request).to_s
    end

    def response_out_of_date?(http_response, current_time=nil)
      (http_response.blank? || header_invalid?(http_response.header) || cache_expired?(http_response.header, current_time)).tap do |expired|
        @client.log(:verbose) { "ApiOperatorCached: Cache response out of date" if expired }
      end
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
