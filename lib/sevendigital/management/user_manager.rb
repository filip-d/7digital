module Sevendigital

  class UserManager < Manager

    def authenticate(email, password)
      request_token = @api_client.oauth.get_request_token
      return nil unless @api_client.oauth.authorise_request_token(email, password, request_token)
      user = Sevendigital::User.new(@api_client)
      user.oauth_access_token = @api_client.oauth.get_access_token(request_token)
      user
    end

    def get_locker(token, options={})
        api_request = Sevendigital::ApiRequest.new("user/locker", {}, options)
        api_request.require_signature
        api_request.token = token
        api_response = @api_client.operator.call_api(api_request)
        @locker = @api_client.locker_digestor.from_xml(api_response.content.locker)
    end

  end

end
