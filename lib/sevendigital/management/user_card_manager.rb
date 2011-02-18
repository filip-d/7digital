module Sevendigital

  class UserCardManager < Manager

    def get_card_list(token, options={})
      api_response = @api_client.make_signed_api_request(:GET, "user/payment/card", {}, options, token)
      @locker = @api_client.user_card_digestor.list_from_xml(api_response.content.cards)
    end

  end
end