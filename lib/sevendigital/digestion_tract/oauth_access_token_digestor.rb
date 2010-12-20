module Sevendigital

  class OAuthAccessTokenDigestor < Digestor

    def default_element_name; :oauth_access_token end

    def from_proxy(token_proxy)
      make_sure_not_eating_nil(token_proxy)
      OAuth::AccessToken.new(@api_client.oauth_consumer, token_proxy.oauth_token.value, token_proxy.oauth_token_secret.value)
    end

  end

end