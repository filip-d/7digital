module Sevendigital

  #@private
  class BasketItemDigestor < Digestor # :nodoc:
    
    def default_element_name; :basketItem end
    def default_list_element_name; :basketItems end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)
      basket_item = BasketItem.new(@api_client)

      basket_item.id = get_required_attribute(xml_node, "id") {|v| v.to_i}
      basket_item.type = get_required_value(xml_node, "type") {|v| v.downcase.to_sym}
      basket_item.artist_name = get_required_value(xml_node, "artistName")
      basket_item.item_name = get_required_value(xml_node, "itemName")
      basket_item.release_id = get_required_value(xml_node, "releaseId") {|v| v.to_i}
      basket_item.track_id = get_required_value(xml_node, "trackId") {|v| v.to_i}
      basket_item.price = get_required_node(xml_node, "price") {|v| @api_client.price_digestor.from_xml_doc(v)}

      basket_item
    end

  end

end
