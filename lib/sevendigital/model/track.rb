module Sevendigital 

  class Track < SevendigitalObject
    attr_accessor :id, :title, :version, :artist
                  
    sevendigital_basic_property :track_number,:duration, :explicit_content, :isrc, :release, :url, :price

    def get_details(options={})
      track_with_details = @api_client.track.get_details(@id, options)
      copy_basic_properties_from(track_with_details)
    end
    
    def short_title
  #   return title.gsub(/\s+[\(\[](album|lp|single|short|edit|radio)\s+version[\)\]]/ , "")
      return title.gsub(/\s+\(.*\s?(version|mix|remix|edit|edition|live|feat|explicit|original)\s?.*\)/i, "")
    end

    def alternate_version_of?(another_track)
      return another_track && short_title.downcase == another_track.short_title.downcase \
            && another_track.artist && artist.name.downcase == another_track.artist.name.downcase
    end

     def preview_url(options={})
      #url = "http://previews.7digital.com/clips/34/#{id}.clip.mp3"
      @api_client.track.build_preview_url(@id, options)
    end

  end
end