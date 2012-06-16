require 'nokogiri'

module Sevendigital

  #@private
  class ArtistDigestor < Digestor # :nodoc:

    def default_element_name; :artist end
    def default_list_element_name; :artists end

    def from_xml_doc(xml_doc)
      make_sure_eating_nokogiri_node(xml_doc)
      artist = Artist.new(@api_client)
      populate_required_properties(artist, xml_doc)
      populate_optional_properties(artist, xml_doc)
      artist
    end

    private
    
    def populate_required_properties(artist, xml_node)
      artist.id = get_required_attribute(xml_node, "id") {|v| v.to_i}
      artist.name = get_required_value(xml_node, "name")
    end

    def populate_optional_properties(artist, artist_node)
      artist.sort_name =  get_optional_value(artist_node, :sortName)
      artist.appears_as = get_optional_value(artist_node, :appearsAs)
      artist.image = get_optional_value(artist_node, :image)
      artist.url = get_optional_value(artist_node, :url)
      artist.popularity = get_optional_value(artist_node, :popularity) {|v| v.to_s.to_d}
    end

  end
end
