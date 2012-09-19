module Sevendigital
  class TrackManager < Manager
    def get_details(id, options={})
      api_response = @api_client.make_api_request(:GET, "track/details", {:trackId => id}, options)
      @api_client.track_digestor.from_xml_doc(api_response.item_xml("track"))
    end

    def get_details_from_release(track_id, release_id, options={})
      @api_client.release.get_tracks(release_id, options).find {|track| track.id == track_id}
    end

    def get_chart(options={})
      api_response = @api_client.make_api_request(:GET, "track/chart", {}, options)
      @api_client.chart_item_digestor.list_from_xml_doc(api_response.item_xml("chart"))
    end

    def build_preview_url(id, options={})
      api_request = @api_client.create_api_request(:GET, "track/preview", {:trackId => id}, options)
      @api_client.operator.get_request_uri(api_request)
    end

    def search(query, options={})
      api_response = @api_client.make_api_request(:GET, "track/search", {:q => query}, options)
      @api_client.track_digestor.nested_list_from_xml_doc(api_response.item_xml("searchResults"), :searchResult, :track)
    end

  end
end