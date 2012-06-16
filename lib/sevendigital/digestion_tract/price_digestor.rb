require 'rational'
module Sevendigital

  #@private
  class PriceDigestor < Digestor # :nodoc:

    def default_element_name; :price end
    def default_list_element_name; nil end
  
    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)
      price = Sevendigital::Price.new()
      get_required_node(xml_node, "currency") do |c|
        price.currency_code = get_required_attribute(c, "code") {|v| v.upcase.to_sym}
      end
      price.currency_symbol = get_required_value(xml_node, "currency")
      price.value = get_required_value(xml_node,"value") {|v| v.to_d unless v.empty?}
      price.formatted_price = get_required_value(xml_node,"formattedPrice")
      price.rrp = get_optional_value(xml_node,"rrp") {|v| v.to_d unless v.empty?}
      price.formatted_rrp = get_optional_value(xml_node,"formattedRrp")
      price.on_sale = get_optional_value(xml_node,"onSale") {|v| v.downcase == "true"}

      price
    end


    end

end