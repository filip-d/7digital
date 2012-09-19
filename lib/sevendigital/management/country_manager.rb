module Sevendigital

  class CountryManager < Manager

    def resolve(ip_address, options={})
      api_response = @api_client.make_api_request(:GET, "country/resolve", {:ipaddress=>ip_address}, options)
      @api_client.country_digestor.from_xml_doc(api_response.item_xml("GeoIpLookup"))
    end

  end
end