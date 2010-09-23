module Sevendigital

  class OAuthManager < Manager

    def get_request_token
      api_request = Sevendigital::ApiRequest.new("oauth/requestToken", {})
      api_request.require_signature
      api_response = @api_client.operator.call_api(api_request)
      @api_client.oauth_request_token_digestor.from_xml(api_response.content.oauth_request_token, :oauth_request_token)
    end

    def get_access_token(request_token)
      api_request = Sevendigital::ApiRequest.new("oauth/requestToken", {})
      api_request.require_signature
      api_request.token = request_token
      api_response = @api_client.operator.call_api(api_request)
      @api_client.oauth_request_token_digestor.from_xml(api_response.content.oauth_request_token, :oauth_access_token)
    end


  end

end
