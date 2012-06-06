module Sevendigital

  #@private
  class DownloadUrlDigestor < Digestor # :nodoc:

    def default_element_name; :downloadUrl end
    def default_list_element_name; :downloadUrls end

    def from_xml_doc(xml_node)
        make_sure_eating_nokogiri_node(xml_node)

        download_url = DownloadUrl.new()

        download_url.url = get_required_value(xml_node,"url")
        download_url.format = get_required_node(xml_node, "format") {|v| @api_client.format_digestor.from_xml_doc(v)}

        download_url
    end


  end

end
