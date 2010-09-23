module Sevendigital

  class User < SevendigitalObject

    attr_accessor :access_token
    
    def authorised?
      return !@access_token.nil?
    end

  end
end