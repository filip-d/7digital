module Sevendigital

  #@private
  class PagerDigestor < Digestor # :nodoc:

    def default_element_name; :results end
    def default_list_element_name; nil end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      return nil unless paging_info_available?(xml_node)

      pager = Pager.new

      pager.page = get_required_value(xml_node,"page").to_i
      pager.page_size = get_required_value(xml_node,"pageSize").to_i
      pager.total_items = get_required_value(xml_node,"totalItems").to_i

      pager
    end

    def paging_info_available?(xml_doc)
      xml_doc.at_xpath("./page") && xml_doc.at_xpath("./pageSize") && xml_doc.at_xpath("./totalItems")
    end

  end
end
