module Sevendigital

  #@private
  class BasketDigestor < Digestor # :nodoc:

    def default_element_name; :basket end

    def from_xml_doc(xml_node)
        make_sure_eating_nokogiri_node(xml_node)
        basket = Sevendigital::Basket.new(@api_client)
        basket.id = get_required_attribute(xml_node, "id")
        basket.basket_items = get_required_node(xml_node, "basketItems") { |v| @api_client.basket_item_digestor.list_from_xml_doc(v) }

        basket
    end

  end

end
