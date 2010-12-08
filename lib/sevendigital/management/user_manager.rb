module Sevendigital

  class UserManager < Manager

    def login(access_token)
      raise Sevendigital::SevendigitalError if !access_token.kind_of? OAuth::AccessToken
      user = Sevendigital::User.new(@api_client)
      user.oauth_access_token = access_token
      user
    end

    def authenticate(email, password)
      request_token = @api_client.oauth.get_request_token
      return nil unless @api_client.oauth.authorise_request_token(email, password, request_token)
      user = Sevendigital::User.new(@api_client)
      user.oauth_access_token = @api_client.oauth.get_access_token(request_token)
      user
    end

    def get_locker(token, options={})
      api_response = @api_client.make_signed_api_request("user/locker", {}, {}, token)
      @locker = @api_client.locker_digestor.from_xml(api_response.content.locker)
    end

    def purchase(release_id, track_id, price, token, options={})
      api_response = @api_client.make_signed_api_request("user/purchase/item", \
        {:releaseId => release_id, :trackId => track_id, :price => price}, options, token)
      @api_client.locker_digestor.from_xml(api_response.content.purchase)
    end

    def get_stream_track_url(release_id, track_id, token, options={})
        api_request = @api_client.create_api_request("user/streamtrack", {:releaseId => release_id, :trackId => track_id}, options)
        api_request.api_service = :media
        api_request.require_signature
        api_request.token = token
        @api_client.operator.get_request_uri(api_request)
    end

    def get_add_card_url(return_url, token, options={})
        api_request = @api_client.create_api_request("payment/addcard", {:returnUrl => return_url}, options)
        api_request.api_service = :account
        api_request.require_signature
        api_request.require_secure_connection
        api_request.token = token
        @api_client.operator.get_request_uri(api_request)
    end


  end

end
