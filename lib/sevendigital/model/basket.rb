module Sevendigital

  class Basket < SevendigitalObject
    attr_accessor :id, :basket_items

    def add_item(release_id, track_id=nil, options={})
      @basket_items = @api_client.basket.add_item(id, release_id, track_id, options).basket_items
    end

    def remove_item(item_id, options={})
      @basket_items = @api_client.basket.remove_item(id, item_id, options).basket_items
    end

  end

end