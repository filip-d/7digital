module Sevendigital

  # provides access to Artist related API methods (artist/*)
  class ArtistManager < Manager

    # calls *artist/details* API method and returns Artist with populated details
    #
    # @param [Integer] artist_id
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [Artist]
    def get_details(artist_id, options={})
      api_response = @api_client.make_api_request(:GET, "artist/details", {:artistId => artist_id}, options)
      @api_client.artist_digestor.from_xml_doc(api_response.item_xml("artist"))
    end

    # calls *artist/releases* API method and returns Release array
    #
    # @param [Integer] artist_id
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [[Artist]]
    def get_releases(artist_id, options={})
      api_response = @api_client.make_api_request(:GET, "artist/releases", {:artistId => artist_id}, options)
      @api_client.release_digestor.list_from_xml_doc(api_response.item_xml("releases"))
    end
      
    # calls *artist/toptracks* API method and returns Track array
    #
    # @param [Integer] artist_id
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [Array<Track>]
      def get_top_tracks(artist_id, options={})
      api_response = @api_client.make_api_request(:GET, "artist/topTracks", {:artistId => artist_id}, options)
      @api_client.track_digestor.list_from_xml_doc(api_response.item_xml("tracks"))
    end

    # calls *artist/similar* API method and returns Artist array
    #
    # @param [Integer] artist_id
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [Array<Artist>]
    def get_similar(artist_id, options={})
      api_response = @api_client.make_api_request(:GET, "artist/similar", {:artistId => artist_id}, options)
      @api_client.artist_digestor.list_from_xml_doc(api_response.item_xml("artists"))
    end

    # calls *artist/byTag/top* API method and returns Artist array
    #
    # @param [String] tags tag or comma separated list of tags
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [Array<Artist>]
    def get_top_by_tag(tags, options={})
      api_response = @api_client.make_api_request(:GET, "artist/byTag/top", {:tags => tags}, options)
      @api_client.artist_digestor.nested_list_from_xml_doc(api_response.item_xml("taggedResults"), :taggedItem, :artist)
    end

    # calls *artist/search* API method and returns Artist array
    #
    # @param [String] query search query
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [Array<Artist>]
    def search(query, options={})
     api_response = @api_client.make_api_request(:GET, "artist/search", {:q => query}, options)
     @api_client.artist_digestor.nested_list_from_xml_doc(api_response.item_xml("searchResults"), :searchResult, :artist)
    end

    # calls *artist/browse* API method and returns Artist array
    #
    # @param [String] letter the letter(s) returned artist names should artists
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [Array<Artist>]
    def browse(letter, options={})
     api_response = @api_client.make_api_request(:GET, "artist/browse", {:letter => letter}, options)
     @api_client.artist_digestor.list_from_xml_doc(api_response.item_xml("artists"))
    end

    # calls *artist/chart* API method and returns Artist array
    #
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    def get_chart(options={})
     api_response = @api_client.make_api_request(:GET, "artist/chart", {}, options)
     @api_client.chart_item_digestor.list_from_xml_doc(api_response.item_xml("chart"))
    end

    # calls *artist/tags* API method and returns Tag array
    #
    # @param [Integer] artist_id
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [Array<Tag>]
    def get_tags(artist_id, options={})
      api_response = @api_client.make_api_request(:GET, "artist/tags", {:artistId => artist_id}, options)
      @api_client.tag_digestor.list_from_xml_doc(api_response.item_xml("tags"))
    end


  end

end
