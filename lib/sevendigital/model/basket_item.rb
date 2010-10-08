module Sevendigital

  class BasketItem < SevendigitalObject

    attr_accessor :id

    sevendigital_basic_property  :type, :artist_name, :item_name, :price, :track_id, :release_id

    sevendigital_extended_property :artist
    sevendigital_extended_property :release
    sevendigital_extended_property :track

  end
  
end