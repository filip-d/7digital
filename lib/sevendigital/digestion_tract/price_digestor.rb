require 'rational'
module Sevendigital

  class PriceDigestor < Digestor # :nodoc:

    def default_element_name; :price end
    def default_list_element_name; nil end
  
    def from_proxy(price_proxy)
        make_sure_not_eating_nil(price_proxy)
        price = Sevendigital::Price.new()
        price.currency_code = price_proxy.currency.code.to_s.upcase.to_sym
        price.currency_symbol= price_proxy.currency.value
        price.value= price_proxy.value.value.to_f if !price_proxy.value.value.to_s.empty?
        price.formatted_price= price_proxy.formatted_price.value
        price.rrp= price_proxy.rrp.value.to_f if price_proxy.rrp
        price.formatted_rrp= price_proxy.formatted_rrp.value if price_proxy.formatted_rrp
        price.on_sale = price_proxy.on_sale.value.to_s.downcase == "true" if price_proxy.on_sale

        return price
      end

    end

end