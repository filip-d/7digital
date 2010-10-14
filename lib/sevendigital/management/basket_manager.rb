module Sevendigital

  class BasketManager < Manager

     def get(id, options={})
        api_request = Sevendigital::ApiRequest.new("basket", {:basketId => id}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end

      def create(options={})
        api_request = Sevendigital::ApiRequest.new("basket/create", {}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end

      def add_item(id, release_id, track_id=nil, options={})
        api_request = Sevendigital::ApiRequest.new("basket/addItem", {:basketId => id, :releaseId => release_id, :trackId => track_id}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end


      def remove_item(id, item_id, options={})
        api_request = Sevendigital::ApiRequest.new("basket/removeItem", {:basketId => id, :itemId => item_id}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.basket_digestor.from_xml(api_response.content.basket)
      end


  end

end
