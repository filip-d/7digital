module Sevendigital

  #@private
  class CountryDigestor < Digestor # :nodoc:

    def default_element_name; :country end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      get_required_value(xml_node, "countryCode")
    end

  end

end