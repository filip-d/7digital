module Sevendigital

  class BasketDigestor < Digestor

    def default_element_name; :basket end

    def from_proxy(basket_proxy)
        make_sure_not_eating_nil (basket_proxy)
        basket = Sevendigital::Basket.new(@api_client)
        basket.id = basket_proxy.id.to_s
        basket.basket_items = @api_client.basket_item_digestor.list_from_proxy(basket_proxy.basket_items)

        return basket
    end

  end

end
