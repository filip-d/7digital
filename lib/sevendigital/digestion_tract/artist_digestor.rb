module Sevendigital

  class ArtistDigestor < Digestor

    def default_element_name; :artist end
    def default_list_element_name; :artists end

    def from_proxy(artist_proxy)
      make_sure_not_eating_nil(artist_proxy)
      artist = Artist.new(@api_client)
      populate_required_properties(artist, artist_proxy)
      populate_optional_properties(artist, artist_proxy)
      return artist
    end

    private
    
    def populate_required_properties(artist, artist_proxy)
      artist.id = artist_proxy.id.to_i
      artist.name = artist_proxy.name.value.to_s
    end

    def populate_optional_properties(artist, artist_proxy)
      artist.sort_name = artist_proxy.sort_name.value.to_s if artist_proxy.sort_name
      artist.appears_as = artist_proxy.appears_as.value.to_s if artist_proxy.appears_as
      artist.image = artist_proxy.image.value.to_s if artist_proxy.image
      artist.url = artist_proxy.url.value.to_s if artist_proxy.url
    end

  end
end
