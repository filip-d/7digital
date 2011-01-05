module Sevendigital

  class BasketItemDigestor < Digestor # :nodoc:
    
    def default_element_name; :basket_item end
    def default_list_element_name; :basket_items end

    def from_proxy(basket_item_proxy)
      make_sure_not_eating_nil(basket_item_proxy)
      basket_item = BasketItem.new(@api_client)

      basket_item.id = basket_item_proxy.id.to_i
      basket_item.type = basket_item_proxy.type.value.downcase.to_sym
      basket_item.artist_name = basket_item_proxy.artist_name.value.to_s
      basket_item.item_name = basket_item_proxy.item_name.value.to_s
      basket_item.release_id = basket_item_proxy.release_id.value.to_i
      basket_item.track_id = basket_item_proxy.track_id.value.to_i
      basket_item.price = @api_client.price_digestor.from_proxy(basket_item_proxy.price)

      return basket_item
    end

  end

end
