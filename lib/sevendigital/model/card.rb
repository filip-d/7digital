module Sevendigital

  class UserCard < SevendigitalObject

    attr_accessor :id

    sevendigital_basic_property  :type, :last_4_digits, :card_holder_name, :expiry_date


  end

end