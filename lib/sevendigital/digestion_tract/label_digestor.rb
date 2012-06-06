module Sevendigital

  #@private
  class LabelDigestor < Digestor # :nodoc:

    def default_element_name; :label end
    def default_list_element_name; :labels end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      label = Label.new()

      label.id = get_required_attribute(xml_node, "id").to_i
      label.name = get_required_value(xml_node, "name")

      label
    end

  end

end