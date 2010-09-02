require "will_paginate/collection"

module Sevendigital

  class Pager
    attr_accessor :page, :page_size, :total_items

    def paginate_list(list)
      paged_list = WillPaginate::Collection.create(@page, @page_size, @total_items) do |pager|
        pager.replace(list)
      end
      return paged_list
    end

  end

end