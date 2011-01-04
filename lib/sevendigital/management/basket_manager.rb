module Sevendigital

  class BasketManager < Manager

     def get(basket_id, options={})
        api_response = @api_client.make_api_request("basket", {:basketId => basket_id}, options)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end

      def create(options={})
        api_response = @api_client.make_api_request("basket/create", {}, options)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end

      def add_item(basket_id, release_id, track_id=nil, options={})
        api_response = @api_client.make_api_request("basket/addItem", {:basketId => basket_id, :releaseId => release_id, :trackId => track_id}, options)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end


      def remove_item(basket_id, item_id, options={})
        api_response = @api_client.make_api_request("basket/removeItem", {:basketId => basket_id, :itemId => item_id}, options)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end


  end

end
