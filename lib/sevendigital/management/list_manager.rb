module Sevendigital

  # provides access to Artist related API methods (artist/*)
  class ListManager < Manager

    # calls *editorial/list* API method and returns Artist with populated details
    #
    # @param [String] key
    # @param [Hash] options optional hash of additional API parameters, e.g. page_size => 50, etc
    # @return [List]
    def get_editorial_list(key, options={})
      api_response = @api_client.make_api_request(:GET, "editorial/list", {:key => key}, options)
      @api_client.list_digestor.from_xml_doc(api_response.item_xml("list"))
    end

  end

end
