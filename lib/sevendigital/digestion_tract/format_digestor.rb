module Sevendigital

  #@private
  class FormatDigestor < Digestor # :nodoc:

    def default_element_name; :format end
    def default_list_element_name; :formats end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      format = Sevendigital::Format.new()

      format.id = get_required_attribute(xml_node,"id").to_i
      format.file_format = get_required_value(xml_node,"fileFormat").to_sym
      format.bit_rate = get_required_value(xml_node,"bitRate").to_i
      format.drm_free = get_required_value(xml_node,"drmFree").downcase == "true"

      format
    end

  end

end
