begin
  require "will_paginate/collection"
rescue LoadError
end

module Sevendigital
  #@private
  #internal class used to page array results if will_paginate is available
  class Pager # :nodoc:
    attr_accessor :page, :page_size, :total_items

    def paginate_list(list)
      return list unless defined?(WillPaginate)
      paged_list = WillPaginate::Collection.create(@page, @page_size, @total_items) do |pager|
        pager.replace(list)
      end
      paged_list
    end
  end
end
