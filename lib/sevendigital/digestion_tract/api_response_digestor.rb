module Sevendigital

  class ApiResponseDigestor < Digestor

    def from_xml(xml_or_proxy, element_name = :response)
      return from_proxy(ProxyPolice.ensure_is_proxy(xml_or_proxy, element_name))
    end

    def from_proxy(proxy)
      if proxy && proxy.status then
        return from_ok_response(proxy)  if proxy.status == 'ok'
        return from_error_response(proxy.error) if proxy.status == 'error' && proxy.error
      end
      return from_invalid_xml
    end

    def from_invalid_xml
      response = ApiResponse.new
      response.error_code = 10000
      response.error_message = 'Invalid 7digital API response'
      return response
    end

    def from_error_response(error)
      response = ApiResponse.new
      response.error_code = error.code.to_i
      response.error_message = error.error_message.value.to_s
      return response
    end

    def from_ok_response(response_content)
      response = ApiResponse.new
      response.error_code = 0
      response.content = response_content
      return response
    end

    def from_http_response(http_response)
      if http_response.is_a?(Net::HTTPSuccess) then
        response = from_xml(http_response.body.to_s)
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
      return response
    end
  
  end

end
