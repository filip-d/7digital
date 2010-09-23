module Sevendigital

  class ApiResponse

    attr_accessor :error_code, :error_message, :content

    def ok?
      return (@error_code == 0 && !@content.nil?)
    end

    def _dump(depth)
      Marshal.dump([@error_code, @error_message, @content.to_s])
    end
    
    def self._load(properties)
      response = ApiResponse.new
      response.error_code, response.error_message, content_xml = Marshal.load(properties)
      response.content = Peachy::Proxy.new(content_xml)
      response
    end


  end

end