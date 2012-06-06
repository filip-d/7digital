module Sevendigital

  #@private
  class LockerDigestor < Digestor # :nodoc:

    def default_element_name; :locker end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)

      locker = Locker.new(@api_client)

      locker.locker_releases = get_required_node(xml_node, "lockerReleases") do |v|
        @api_client.locker_release_digestor.list_from_xml_doc(v)
      end

      locker
    end

  end

end
