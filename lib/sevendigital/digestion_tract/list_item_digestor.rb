module Sevendigital

  #@private
  class ListItemDigestor < Digestor # :nodoc:
    
    def default_element_name; :listItem end
    def default_list_element_name; :listItems end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      list_item = Sevendigital::ListItem.new(@api_client)

      list_item.id = get_required_attribute(xml_node, "id").to_i
      list_item.type = get_required_value(xml_node, "type").to_sym

      list_item.release = get_required_node(xml_node, "release") do |v|
        @api_client.release_digestor.from_xml_doc(v)
      end

      list_item
    end

  end

end
