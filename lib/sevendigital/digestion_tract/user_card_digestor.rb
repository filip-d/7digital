module Sevendigital

  #@private
  class UserCardDigestor < Digestor # :nodoc:

    def default_element_name; :card end
    def default_list_element_name; :cards end
    
    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      card = Sevendigital::Card.new(@api_client)

      card.id = get_optional_attribute(xml_node,"id").to_i
      card.type = get_required_value(xml_node, "type")
      card.last_4_digits = get_required_value(xml_node, "last4digits")
      card.card_holder_name = get_optional_value(xml_node, "cardHolderName")
      card.expiry_date = get_optional_value(xml_node, "expiryDate")

      card
    end

  end

end