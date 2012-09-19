module Sevendigital

  #@private
  class ListDigestor < Digestor # :nodoc:

    def default_element_name; :list end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      list = List.new(@api_client)

      list.id = get_required_attribute(xml_node, "id").to_i
      list.key = get_required_value(xml_node, "key")
      list.list_items = get_required_node(xml_node, "listItems") do |v|
        @api_client.list_item_digestor.list_from_xml_doc(v)
      end

      list
    end

  end

end
