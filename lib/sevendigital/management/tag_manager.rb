module Sevendigital

  class TagManager < Manager

    def get_tag_list(options={})
      api_response = @api_client.make_api_request(:GET, "tag", {}, options)
      @api_client.tag_digestor.list_from_xml_doc(api_response.item_xml("tags"))
    end

  end
end