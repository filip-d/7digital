module Sevendigital

  class OAuthManager < Manager

    def get_oauth_request_token
      api_request = Sevendigital::ApiRequest.new("oauth/requestToken", {})
      api_request.require_signature
      api_response = @api_client.operator.call_api(api_request)
      @api_client.request_token_digestor.from_xml(api_response.content.oauth_request_token)
    end

  end

end
