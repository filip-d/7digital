module Sevendigital

  class UserCardManager < Manager

    def get_card_list(token, options={})
      api_response = @api_client.make_signed_api_request(:GET, "user/payment/card", {}, options, token)
      @api_client.user_card_digestor.list_from_xml(api_response.content.cards)
    end

    def add_card(card_number, card_type, card_holder_name, card_start_date, card_expiry_date, card_issue_number,
            card_verification_code, card_post_code, card_country, token, options={})
      api_response = @api_client.make_signed_api_request(:POST, "user/payment/card/add", {
          :cardNumber => card_number, :cardType => card_type, :cardHolderName => card_holder_name,
          :cardStartDate => card_start_date, :cardExpiryDate => card_expiry_date, :cardIssueNumber => card_issue_number,
          :cardVerificationCode => card_verification_code, :cardPostCode => card_post_code, :cardCountry => card_country
        }, options, token)
      @api_client.user_card_digestor.from_xml(api_response.content.card)
    end

  end
end