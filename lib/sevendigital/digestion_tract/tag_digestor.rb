module Sevendigital

  #@private
  class TagDigestor < Digestor # :nodoc:

    def default_element_name; :tag end
    def default_list_element_name; :tags end
    
    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      tag = Tag.new()

      tag.id = get_required_attribute(xml_node, "id")
      tag.text = get_required_value(xml_node, "text")
      tag.url = get_optional_value(xml_node, "url")
      tag.count = get_optional_value(xml_node, "count") {|v| v.to_i}

      tag
    end

  end

end