module Sevendigital

  #@private
  class TrackDigestor < Digestor # :nodoc:

    def default_element_name; :track end
    def default_list_element_name; :tracks end

    def from_xml_doc(xml_node)
         make_sure_eating_nokogiri_node(xml_node)

         track = Track.new(@api_client)

         populate_required_properties(track, xml_node)
         populate_optional_properties(track, xml_node)

         track
       end

       def populate_required_properties(track, xml_node)
         track.id = get_required_attribute(xml_node, "id").to_i
         track.title = get_required_value(xml_node, "title")
         track.artist = get_required_node(xml_node, "artist") {|v| @api_client.artist_digestor.from_xml_doc(v) }
       end

       def populate_optional_properties(track, xml_node)
         track.version = get_optional_value(xml_node, "version")
         track.track_number = get_optional_value(xml_node, "trackNumber") {|v| v.to_i}
         track.duration = get_optional_value(xml_node, "duration") {|v| v.to_i}
         track.release = get_optional_node(xml_node, "release") {|v |@api_client.release_digestor.from_xml_doc(v)}
         track.explicit_content = get_optional_value(xml_node, "explicitContent") {|v| v.downcase == "true"}
         track.isrc = get_optional_value(xml_node, "isrc")
         track.url = get_optional_value(xml_node, "url")
         track.price =  get_optional_node(xml_node, "price") {|v| @api_client.price_digestor.from_xml_doc(v)}
         track.type = get_optional_value(xml_node, "type") {|v| v.to_s.downcase.to_sym}
       end
  end
end
