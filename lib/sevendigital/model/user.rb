module Sevendigital

  class User < SevendigitalObject

    attr_accessor :oauth_access_token
    
    def authenticated?
      return !@oauth_access_token.nil?
    end

  end
end