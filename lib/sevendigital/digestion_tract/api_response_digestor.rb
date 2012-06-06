module Sevendigital

  #@private
  class ApiResponseDigestor < Digestor # :nodoc:

    def default_element_name; :response end

    def from_xml_doc(xml_node)
      return from_invalid_xml unless xml_node

      status = get_optional_attribute(xml_node, "status")

      return from_ok_response(xml_node)  if status == 'ok'

      return from_error_response(xml_node) if status == 'error'

      from_invalid_xml
    end

    def from_invalid_xml
      response = ApiResponse.new

      response.error_code = 10000
      response.error_message = 'Invalid 7digital API response'

      response
    end

    def from_error_response(xml_node)

      error_node = get_required_node(xml_node, "error")

      response = ApiResponse.new

      response.error_code = get_required_attribute(error_node, "code").to_i
      response.error_message = get_required_value(error_node, "errorMessage")

      response
    end

    def from_ok_response(response_content)
      response = ApiResponse.new

      response.error_code = 0
      response.content = response_content

      response
    end

    def from_http_response(http_response)
      if http_response.is_a?(Net::HTTPSuccess) then
        response = from_xml_nokogiri(http_response.body.to_s)
      else
        response = from_invalid_http_response(http_response)
      end
      response.headers = http_response.header
      response
    end

    def from_invalid_http_response(http_response)
      response = ApiResponse.new

      response.error_code = Integer(http_response.code)
      response.error_message= http_response.body.to_s

      response
    end
  
  end

end
