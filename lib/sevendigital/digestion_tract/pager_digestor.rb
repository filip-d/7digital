module Sevendigital

  #@private
  class PagerDigestor < Digestor # :nodoc:

    def default_element_name; :results end
    def default_list_element_name; nil end

    def from_proxy(pager_proxy)
      make_sure_not_eating_nil(pager_proxy)
      return nil unless paging_info_available?(pager_proxy)
      pager = Pager.new
      pager.page = pager_proxy.page.value.to_i
      pager.page_size = pager_proxy.page_size.value.to_i
      pager.total_items = pager_proxy.total_items.value.to_i
      return pager
    end

    def from_xml_doc(xml_doc)
      make_sure_eating_nokogiri_node(xml_doc)
      return nil unless paging_info_available_xml?(xml_doc)
      pager = Pager.new
      pager.page = xml_doc.at_xpath("./page").content.to_i
      pager.page_size = xml_doc.at_xpath("./pageSize").content.to_i
      pager.total_items = xml_doc.at_xpath("./totalItems").content.to_i
      pager
    end

    def paging_info_available?(pager_proxy)
      pager_proxy.page && pager_proxy.page_size && pager_proxy.total_items
    end

    def paging_info_available_xml?(xml_doc)
      xml_doc.at_xpath("./page") && xml_doc.at_xpath("./pageSize") && xml_doc.at_xpath("./totalItems")
    end

  end
end
