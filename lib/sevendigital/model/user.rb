module Sevendigital

  class User < SevendigitalObject

    attr_accessor :oauth_access_token, :id, :type, :email_address

    sevendigital_extended_property :locker

    def authenticated?
      return !@oauth_access_token.nil?
    end

    def get_locker(options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.get_locker(@oauth_access_token, options)
    end

    def purchase!(release_id, track_id, price, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.purchase(release_id, track_id, price, @oauth_access_token, options)
    end

    def stream_track_url(release_id, track_id, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.get_stream_track_url(release_id, track_id, @oauth_access_token, options)
    end

    def add_card_url(return_url, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.get_add_card_url(return_url, @oauth_access_token, options)
    end

  end
end