module Sevendigital

  #@private
  class CardDigestor < Digestor # :nodoc:

    def default_element_name; :card end
    
    def from_proxy(card_proxy)
      make_sure_not_eating_nil(card_proxy)

      card = Sevendigital::Card.new(@api_client)
      card.id = card_proxy.id.to_s
      card.type = card_proxy.type.value.to_s
      card.last_4_digits = card_proxy.last_4_digits.value.to_s
      card.card_holder_name = card_proxy.card_holder_name.value.to_s if value_present?(card_proxy.card_holder_name)
      card.expiry_date = card_proxy.expiry_date.value.to_s if value_present?(card_proxy.expiry_date)

      return card
    end

  end

end