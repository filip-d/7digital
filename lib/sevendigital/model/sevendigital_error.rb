module Sevendigital
  class SevendigitalError < StandardError;
    attr :error_code, :error_message

    def initialize(error_code = 10000, error_message=nil)
      @error_code = error_code
      @error_message = error_message
    end

  end
end
