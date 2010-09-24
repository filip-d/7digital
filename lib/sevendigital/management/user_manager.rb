module Sevendigital

  class UserManager < Manager

    def authenticate(email, password)
      request_token = @api_client.oauth.get_request_token
      return nil unless @api_client.oauth.authorise_request_token(email, password, request_token)
    end

  end

end
