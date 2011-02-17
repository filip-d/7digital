module Sevendigital

  class OAuthManager < Manager

    def get_request_token
      api_response = @api_client.make_signed_api_request(:GET, "oauth/requestToken", {})
      @api_client.oauth_request_token_digestor.from_xml(api_response.content.oauth_request_token, :oauth_request_token)
    end

    def get_access_token(request_token)
      api_response = @api_client.make_signed_api_request(:GET, "oauth/accessToken", {}, {}, request_token)
      @api_client.oauth_access_token_digestor.from_xml(api_response.content.oauth_access_token, :oauth_access_token)
    end

    def authorise_request_token(username, password, request_token)
      api_response = @api_client.make_signed_api_request(:GET, "oauth/requestToken/authorise", \
        {:username => username, :password => password, :token => request_token.token})
      api_response.ok?
    end

  end

end
