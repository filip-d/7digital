module Sevendigital

  #Holds the complete API response
  class ApiResponse

    attr_accessor :error_code, :error_message, :content, :headers

    #True if no API error has been returned
    def ok?
      return (@error_code == 0 && !@content.nil?)
    end

    def _dump(depth)
      Marshal.dump([@error_code, @error_message, @headers, @content.to_s])
    end
    
    def self._load(properties)
      response = ApiResponse.new
      response.error_code, response.error_message, response.headers, content_xml = Marshal.load(properties)
      response.content = Peachy::Proxy.new(content_xml).response
      response
    end

  end

end