module Sevendigital

  class TrackManager < Manager

    def get_details(id, options={})
      api_request = Sevendigital::ApiRequest.new("track/details", {:trackId => id}, options)
      api_response = @api_client.operator.call_api(api_request)
      @api_client.track_digestor.from_xml(api_response.content.track)
    end

    #TODO TEST THIS METHOD
    def get_details_from_release(track_id, release_id, options={})
      @api_client.release.get_tracks(release_id, options).find {|track| track.id = track_id}
    end

    def get_chart(options={})
      api_request = Sevendigital::ApiRequest.new("track/chart", {}, options)
      api_response = @api_client.operator.call_api(api_request)
      @api_client.chart_item_digestor.list_from_xml(api_response.content.chart)
    end

    def build_preview_url(id, options={})
      api_request = Sevendigital::ApiRequest.new("track/preview", {:trackId => id}, options)
      @api_client.operator.create_request_uri(api_request)
    end

    def search(query, options={})
      api_request = Sevendigital::ApiRequest.new("track/search", {:q => query}, options)
      api_response = @api_client.operator.call_api(api_request)
      @api_client.track_digestor.nested_list_from_xml(api_response.content.search_results, :search_result, :search_results)
    end
  end
end