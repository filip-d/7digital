module Sevendigital

  #@private
  class OAuthAccessTokenDigestor < Digestor # :nodoc:

    def default_element_name; :oauth_access_token end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)
      OAuth::AccessToken.new(
              @api_client.oauth_consumer,
              get_required_value(xml_node,"oauth_token"),
              get_required_value(xml_node,"oauth_token_secret")
      )
    end

  end

end