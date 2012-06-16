require 'nokogiri'

module Sevendigital

  #@private
  class ApiResponseDigestor < Digestor # :nodoc:

    def default_element_name; :response end

    def from_http_response(http_response)
      response = ApiResponse.new
      response.headers = http_response.header
      response.content = http_response.body.to_s

      parse_xml_doc(response.content, response)

      if response.error_code >= 10000 && !http_response.is_a?(Net::HTTPSuccess)
        response.error_code = Integer(http_response.code)
        response.error_message= http_response.body.to_s
      end
      response
    end

    def parse_xml_doc(xml, response)

      xml_doc = Nokogiri::XML(xml)

      response_node = xml_doc.at_xpath("./response")
      response_status = nil
      response_status = get_optional_attribute(response_node, "status") if response_node
      puts xml.inspect
      if response_status == 'ok' then
        response.error_code = 0
      else
        if response_status == 'error'
          error_node = get_required_node(response_node, "error")
          response.error_code = get_required_attribute(error_node, "code").to_i
          response.error_message = get_required_value(error_node, "errorMessage")
        else
          response.error_code = 10001
          response.error_message = 'Invalid 7digital API response'
        end
      end

    end

  end

end
