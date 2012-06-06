module Sevendigital

  #@private
  class LockerTrackDigestor < Digestor # :nodoc:
    
    def default_element_name; :lockerTrack end
    def default_list_element_name; :lockerTracks end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      locker_track = Sevendigital::LockerTrack.new(@api_client)

      locker_track.track = get_required_node(xml_node, "track") {|v| @api_client.track_digestor.from_xml_doc(v)}
      locker_track.remaining_downloads = get_required_value(xml_node, "remainingDownloads").to_i
      locker_track.purchase_date = DateTime.parse(get_required_value(xml_node, "purchaseDate"))
      locker_track.download_urls = get_required_node(xml_node, "downloadUrls") do |v|
        @api_client.download_url_digestor.list_from_xml_doc(v)
      end

      locker_track
    end

  end

end
