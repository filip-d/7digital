module Sevendigital

  class TrackDigestor < Digestor

    def default_element_name; :track end
    def default_list_element_name; :tracks end


    def from_proxy(track_proxy)
      make_sure_not_eating_nil (track_proxy)

      track = Track.new(@api_client)
      populate_required_properties(track, track_proxy)
      populate_optional_properties(track, track_proxy)

      return track
    end

    def populate_required_properties(track, track_proxy)
      track.id = track_proxy.id.to_i
      track.title = track_proxy.title.value.to_s
      track.artist = @api_client.artist_digestor.from_proxy(track_proxy.artist)
    end

    def populate_optional_properties(track, track_proxy)
      track.version = track_proxy.version.value.to_s if track_proxy.version
      track.track_number = track_proxy.track_number.value.to_i if track_proxy.track_number
      track.duration = track_proxy.duration.value.to_i if track_proxy.duration
      track.release = @api_client.release_digestor.from_proxy(track_proxy.release) if track_proxy.release
      track.explicit_content = track_proxy.explicit_content.value.to_s.downcase == "true" if track_proxy.explicit_content
      track.isrc = track_proxy.isrc.value.to_s if track_proxy.isrc
      track.image = track_proxy.image.value.to_s if track_proxy.image
      track.url = track_proxy.url.value.to_s if track_proxy.url
      track.price = @api_client.price_digestor.from_proxy(track_proxy.price) if track_proxy.price
    end
  end
end
