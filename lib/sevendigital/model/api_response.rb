module Sevendigital

  #Holds the complete API response
  class ApiResponse

    attr_accessor :error_code, :error_message, :content, :headers

    #True if no API error has been returned
    def ok?
      (@error_code == 0 && !@content.nil?)
    end

    def content_xml
      @content_xml ||= Nokogiri::XML(@content)
    end

    def item_xml(element_name)
      content_xml.at_xpath("./response/#{element_name}")
    end

    def _dump(depth)
      Marshal.dump([@error_code, @error_message, @headers, @content])
    end
    
    def self._load(properties)
      response = ApiResponse.new
      response.error_code, response.error_message, response.headers, response.content = Marshal.load(properties)
      response
    end

  end

end