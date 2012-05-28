module Sevendigital

  #@private
  class TrackDigestor < Digestor # :nodoc:

    def default_element_name; :track end
    def default_list_element_name; :tracks end


    def from_proxy(track_proxy)
      from_xml_nokogiri(track_proxy.to_s)
    end

    def from_xml_doc(node)
         make_sure_eating_nokogiri_node(node)
         track = Track.new(@api_client)
         populate_required_properties_nokogiri(track, node)
         populate_optional_properties_nokogiri(track, node)

         return track
       end

       def populate_required_properties_nokogiri(track, xml_node)
         track.id = xml_node["id"].to_i
         track.title = xml_node.at_xpath("./title").content.to_s
         track.artist = @api_client.artist_digestor.from_xml_doc(xml_node.at_xpath("./artist"))
       end

       def populate_optional_properties_nokogiri(track, xml_node)
         track.version = get_optional_value(xml_node, "version")
         track.track_number = get_optional_value(xml_node, "trackNumber") {|v| v.to_i}
         track.duration = get_optional_value(xml_node, "duration") {|v| v.to_i}
         track.release = get_optional_node(xml_node, "release") {|release_node |@api_client.release_digestor.from_xml_doc(release_node)}
         track.explicit_content =  get_optional_value(xml_node, "explicitContent") {|v| v.to_s.downcase == "true"}
         track.isrc = get_optional_value(xml_node, "isrc")
         track.url = get_optional_value(xml_node, "url")
         track.price =  get_optional_node(xml_node, "price") {|v| @api_client.price_digestor.from_xml(v.to_s)}

       end
  end
end
