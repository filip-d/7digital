module Sevendigital

  class User < SevendigitalObject

    attr_accessor :oauth_access_token, :id, :type

    #Artist image URL (optional lazy-loaded property)
    #@return [String]
    sevendigital_basic_property :email_address

    sevendigital_extended_property :locker

    sevendigital_extended_property :cards

    def authenticated?
      return !@oauth_access_token.nil?
    end

    def get_details(options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      user_with_details = @api_client.user.get_details(@oauth_access_token, options)
      copy_basic_properties_from(user_with_details)
      user_with_details
    end

    def get_locker(options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.get_locker(@oauth_access_token, options)
    end

    def get_cards(options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user_payment_card.get_card_list(@oauth_access_token, options)
    end

    def add_card(card_number, card_type, card_holder_name, card_start_date, card_expiry_date, card_issue_number,
            card_verification_code, card_post_code, card_country, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user_payment_card.add_card(card_number, card_type, card_holder_name, card_start_date, card_expiry_date, card_issue_number,
            card_verification_code, card_post_code, card_country, @oauth_access_token, options)
    end

    def select_card(card_id, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user_payment_card.select_card(card_id, @oauth_access_token, options)
    end

    # <b>DEPRECATED:</b> Please use <tt>purchase_item!</tt> instead.
    def purchase!(release_id, track_id, price, token, options={})
      warn "[DEPRECATION] `purchase!` is deprecated.  Please use 'purchase_item!' instead."
      purchase_item!(release_id, track_id, price, options={})
    end

    def purchase_item!(release_id, track_id, price, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.purchase_item(release_id, track_id, price, @oauth_access_token, options)
    end

    def purchase_basket!(basket_id, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.purchase_basket(basket_id, @oauth_access_token, options)
    end

    def stream_track_url(release_id, track_id, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.get_stream_track_url(release_id, track_id, @oauth_access_token, options)
    end

    def add_card_url(return_url, options={})
      raise Sevendigital::SevendigitalError if !authenticated?
      @api_client.user.get_add_card_url(return_url, @oauth_access_token, options)
    end

  end
end