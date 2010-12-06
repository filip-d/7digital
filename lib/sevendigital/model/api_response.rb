module Sevendigital

  class ApiResponse

    attr_accessor :error_code, :error_message, :content, :headers

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

    def out_of_date?(current_time=nil)
      return true if @headers.nil? || @headers["Date"].nil? || @headers["cache-control"].nil?
      return true if  !(@headers["cache-control"] =~ /max-age=([0-9]+)/)
      current_time ||= Time.now.utc
      response_time = Time.parse(@headers["Date"])
      max_age = /max-age=([0-9]+)/.match(@headers["cache-control"])[1].to_i
      response_time + max_age < current_time
    end


  def response_cacheable?
    return true
  end

  end

end