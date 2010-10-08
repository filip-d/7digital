module Sevendigital

  class OAuthRequestTokenDigestor < Digestor

    def default_element_name; :oauth_request_token end

    def from_proxy(token_proxy)
      make_sure_not_eating_nil(token_proxy)
      OAuth::RequestToken.new(nil, token_proxy.oauth_token.value, token_proxy.oauth_token_secret.value)
    end

  end

end