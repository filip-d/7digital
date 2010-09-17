require "peachy"

module Sevendigital

  class ArtistManager < Manager

     def get_details(id, options={})
        api_request = Sevendigital::ApiRequest.new("artist/details", {:artistId => id}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.artist_digestor.from_xml(api_response.content.artist)
      end

      def get_releases(id, options={})
        api_request = Sevendigital::ApiRequest.new("artist/releases", {:artistId => id}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.release_digestor.list_from_xml(api_response.content.releases)
      end
      
      def get_top_tracks(id, options={})
        api_request = Sevendigital::ApiRequest.new("artist/toptracks", {:artistId => id}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.track_digestor.list_from_xml(api_response.content.tracks)
      end

      def get_similar(id, options={})
        api_request = Sevendigital::ApiRequest.new("artist/similar", {:artistId => id}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.artist_digestor.list_from_xml(api_response.content.artists)
      end

      def get_top_by_tag(tags, options={})
        api_request = Sevendigital::ApiRequest.new("artist/byTag/top", {:tags => tags}, options)
        api_response = @api_client.operator.call_api(api_request)
        @api_client.artist_digestor.nested_list_from_xml(api_response.content.tagged_results, :tagged_item, :tagged_results)
      end

       def search(query, options={})
         api_request = Sevendigital::ApiRequest.new("artist/search", {:q => query}, options)
         api_response = @api_client.operator.call_api(api_request)
         @api_client.artist_digestor.nested_list_from_xml(api_response.content.search_results, :search_result, :search_results)
       end

  end

end
