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

    def paging_info_available?(pager_proxy)
      pager_proxy.page && pager_proxy.page_size && pager_proxy.total_items
    end

  end
end
