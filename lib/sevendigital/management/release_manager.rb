require "peachy"

module Sevendigital

  class ReleaseManager < Manager

    def get_details(release_id, options = {})
      api_response = @api_client.make_api_request(:GET, "release/details", {:releaseId => release_id}, options)
      @api_client.release_digestor.from_xml(api_response.content.release)
    end

    def get_tracks(release_id, options = {})
      options[:page_size] ||= 100
      api_response = @api_client.make_api_request(:GET, "release/tracks", {:releaseId => release_id}, options)
      @api_client.track_digestor.list_from_xml(api_response.content.tracks)
    end

    def get_chart(options={})
      api_response = @api_client.make_api_request(:GET, "release/chart", {}, options)
      @api_client.chart_item_digestor.list_from_xml(api_response.content.chart)
    end

    def get_by_date(from_date = nil, to_date = nil, options = {})
      parameters = Hash.new
      parameters[:fromDate] = from_date.strftime("%Y%m%d") if from_date
      parameters[:toDate] = to_date.strftime("%Y%m%d") if to_date

      api_response = @api_client.make_api_request(:GET, "release/byDate", parameters, options)
      @api_client.release_digestor.list_from_xml(api_response.content.releases)
    end

    def get_recommendations(release_id, options = {})
      api_response = @api_client.make_api_request(:GET, "release/recommend", {:releaseId => release_id}, options)
      @api_client.release_digestor.nested_list_from_xml(api_response.content.recommendations, :recommended_item, :recommendations)
    end


    def get_top_by_tag(tags, options = {})
      api_response = @api_client.make_api_request(:GET, "release/byTag/top", {:tags => tags}, options)
      @api_client.release_digestor.nested_list_from_xml( \
      api_response.content.tagged_results, :tagged_item, :tagged_results )
    end

    def search(query, options={})
      api_response = @api_client.make_api_request(:GET, "release/search", {:q => query}, options)
      @api_client.release_digestor.nested_list_from_xml(api_response.content.search_results, :search_result, :search_results)
    end


    def get_tags(release_id, options = {})
      api_response = @api_client.make_api_request(:GET, "release/tags", {:releaseId => release_id}, options)
      @api_client.tag_digestor.list_from_xml(api_response.content.tags)
    end

  end

end