module Sevendigital

  require 'date'

  #@private
  class ReleaseDigestor < Digestor # :nodoc:
    
    def default_element_name; :release end
    def default_list_element_name; :releases end

    def from_proxy(release_proxy)
      make_sure_not_eating_nil(release_proxy)
      release = Release.new(@api_client)

      populate_required_properties(release, release_proxy)
      populate_optional_properties(release, release_proxy)
      populate_formats(release, release_proxy)

      return release
    end

    def from_xml_doc(xml_node)
      make_sure_eating_nokogiri_node(xml_node)
      release = Release.new(@api_client)
      populate_required_properties_nokogiri(release, xml_node)
      populate_optional_properties_nokogiri(release, xml_node)
      populate_formats_nokogiri(release, xml_node)
      release
    end

      def populate_required_properties(release, release_proxy)
        release.id = release_proxy.id.to_i
        release.title = release_proxy.title.value.to_s
        release.artist = @api_client.artist_digestor.from_proxy(release_proxy.artist)
      end

      def populate_optional_properties(release, release_proxy)
        release.version = release_proxy.version.value.to_s if release_proxy.version
        release.type = release_proxy.type.value.downcase.to_sym if value_present?(release_proxy.type)
        release.barcode = release_proxy.barcode.value.to_s if value_present?(release_proxy.barcode)
        release.year = release_proxy.year.value.to_i if value_present?(release_proxy.year)
        release.explicit_content = release_proxy.explicit_content.value.to_s.downcase == "true" if value_present?(release_proxy.explicit_content)
        release.release_date = DateTime.parse(release_proxy.release_date.value.to_s) if value_present?(release_proxy.release_date)
        release.added_date = DateTime.parse(release_proxy.added_date.value.to_s) if value_present?(release_proxy.added_date)
        release.label =  @api_client.label_digestor.from_proxy(release_proxy.label) if content_present?(release_proxy.label)
        release.image = release_proxy.image.value.to_s if value_present?(release_proxy.image)
        release.url = release_proxy.url.value.to_s if value_present?(release_proxy.url)
        release.price =  @api_client.price_digestor.from_proxy(release_proxy.price) if content_present?(release_proxy.price)
      end

      def populate_formats(release, release_proxy)
        if release_proxy.formats && release_proxy.formats.format then
          release.formats = Array.new
          release_proxy.formats.format.each do |format|
            release.formats <<  @api_client.format_digestor.from_proxy(format)
          end
        end
      end

    def populate_required_properties_nokogiri(release, xml_node)
      release.id = xml_node["id"].to_i
      release.title = xml_node.at_xpath("./title").content.to_s
      release.artist = @api_client.artist_digestor.from_xml_doc(xml_node.at_xpath("./artist"))
    end

    def populate_optional_properties_nokogiri(release, xml_node)
      release.version =  get_optional_value(xml_node, "version")
      release.type =  get_optional_value(xml_node, "type") {|v| v.to_s.downcase.to_sym}
      release.barcode =  get_optional_value(xml_node, "barcode")
      release.year =  get_optional_value(xml_node, "year") {|v| v.to_i}
      release.explicit_content =  get_optional_value(xml_node, "explicitContent") {|v| v.to_s.downcase == "true"}
      release.release_date =  get_optional_value(xml_node, "releaseDate") {|v| DateTime.parse(v)}
      release.added_date =  get_optional_value(xml_node, "addedDate") {|v| DateTime.parse(v)}
      release.label =  get_optional_node(xml_node, "label") {|v| @api_client.label_digestor.from_xml(v.to_s)}
      release.image =  get_optional_value(xml_node, "image")
      release.url =  get_optional_value(xml_node, "url")
      release.price =  get_optional_node(xml_node, "price") {|v| @api_client.price_digestor.from_xml(v.to_s)}

    end

    def populate_formats_nokogiri(release, xml_node)
      formats_node = get_optional_node(xml_node, "formats")
      return unless formats_node
      release.formats = Array.new
      formats_node.xpath("./format").each do |format_node|
        release.formats <<  @api_client.format_digestor.from_xml(format_node.to_s)
      end
    end

  end

end
