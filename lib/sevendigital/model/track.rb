module Sevendigital 

  class Track < SevendigitalObject
    attr_accessor :id, :title, :version, :artist, :track_number,
                  :duration, :explicit_content, :isrc, :release, :url, :price

  end
end