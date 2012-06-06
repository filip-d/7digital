module Sevendigital

  #@private
  class UserDigestor < Digestor # :nodoc:

    def default_element_name; :user end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      user = User.new(@api_client)

      user.id = get_optional_attribute(xml_node, "id")
      user.type = get_required_value(xml_node, "type").to_sym
      user.email_address = get_optional_value(xml_node, "emailAddress")

      user
    end

  end

end