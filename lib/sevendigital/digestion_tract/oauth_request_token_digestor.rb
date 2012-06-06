module Sevendigital

  #@private
  class OAuthRequestTokenDigestor < Digestor # :nodoc:

    def default_element_name; :oauth_request_token end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)
      OAuth::RequestToken.new(
              @api_client.oauth_consumer,
              get_required_value(xml_node,"oauth_token"),
              get_required_value(xml_node,"oauth_token_secret")
      )
    end

  end

end