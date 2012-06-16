module Sevendigital

  #@private
  class ChartItemDigestor < Digestor # :nodoc:

    def default_element_name; :chartItem end
    def default_list_element_name; :chart end
    
    def from_proxy(chart_item_proxy)
      
      from_xml_string(chart_item_proxy.to_s)

    end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      chart_item = ChartItem.new(@client)

      chart_item.position = get_required_value(xml_node, "position") {|v| v.to_i}
      chart_item.change = get_required_value(xml_node, "change") {|v| v.downcase.to_sym}
      if xml_node.at_xpath("./release") then
        chart_item.item = get_required_node(xml_node, "release") {|v| @api_client.release_digestor.from_xml_doc(v) }
      elsif xml_node.at_xpath("./track")
        chart_item.item = get_required_node(xml_node, "track") {|v| @api_client.track_digestor.from_xml_doc(v) }
      else
        chart_item.item = get_required_node(xml_node, "artist") {|v| @api_client.artist_digestor.from_xml_doc(v) }
      end
      return chart_item
    end

  end
  
end
