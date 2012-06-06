module Sevendigital

  #@private
  class LockerReleaseDigestor < Digestor # :nodoc:
    
    def default_element_name; :lockerRelease end
    def default_list_element_name; :lockerReleases end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      locker_release = Sevendigital::LockerRelease.new(@api_client)

      locker_release.release = get_required_node(xml_node, "release") do |v|
        @api_client.release_digestor.from_xml_doc(v)
      end
      locker_release.locker_tracks = get_required_node(xml_node, "lockerTracks") do |v|
        @api_client.locker_track_digestor.list_from_xml_doc(v)
      end

      locker_release
    end

  end

end
