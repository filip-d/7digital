module Sevendigital

  class ApiResponse

    attr_accessor :error_code, :error_message, :content

    def is_ok?
      return (@error_code == 0 && !@content.nil?)
    end

  end

end