module Sevendigital

  #@private
  class ChartItemDigestor < Digestor # :nodoc:

    def default_element_name; :chart_item end
    def default_list_element_name; :chart end
    
    def from_proxy(chart_item_proxy)
      
      make_sure_not_eating_nil(chart_item_proxy)
      
      chart_item = ChartItem.new(@client)
      chart_item.position = chart_item_proxy.position.value.to_i
      chart_item.change = chart_item_proxy.change.value.to_s.downcase.to_sym
      if chart_item_proxy.release then
        chart_item.item = @api_client.release_digestor.from_proxy(chart_item_proxy.release)
      elsif chart_item_proxy.track
        chart_item.item = @api_client.track_digestor.from_proxy(chart_item_proxy.track)
      else
        chart_item.item = @api_client.artist_digestor.from_proxy(chart_item_proxy.artist)
      end
      return chart_item
     end

  end
  
end
