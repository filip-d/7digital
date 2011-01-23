module Sevendigital

  class TagDigestor < Digestor # :nodoc:

    def default_element_name; :tag end
    def default_list_element_name; :tags end
    
    def from_proxy(tag_proxy)
      make_sure_not_eating_nil(tag_proxy)

      tag = Tag.new()
      tag.id = tag_proxy.id.to_s
      tag.text = tag_proxy.text.value.to_s
      tag.url = tag_proxy.url.value.to_s if value_present?(tag_proxy.url)
      tag.count = tag_proxy.count.value.to_i  #if value_present?(tag_proxy.count)

      return tag
    end

  end

end