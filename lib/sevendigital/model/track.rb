module Sevendigital 

  class Track < SevendigitalObject

    #track id
    #@return [Integer]
    attr_accessor :id

    #title of the track
    #@return [String]
    attr_accessor :title

    #version of the track (e.g. remix, radio edit)
    #@return [String]
    attr_accessor :version

    #release the track appears on
    #@return [Release]
    attr_accessor :release

    #Artist of the track
    #@return [Artist]
    attr_accessor :artist
                  
    #Number of the track as it appears on the release
    #@return [Integer]
    sevendigital_basic_property :track_number

    #The length of the track in seconds
    #@return [Integer]
    sevendigital_basic_property :duration

    #parental advisory - explicit content tag
    #@return [Boolean]
    sevendigital_basic_property :explicit_content

    #ISRC code
    #@return [String]
    sevendigital_basic_property :isrc

    #URL link to 7digital page where this track can be purchased
    #@return [String]
    sevendigital_basic_property :url

    #Pricing information of the track
    #@return [Price]
    sevendigital_basic_property :price

    #Track type, e.g. :audio, :video, :pdf, etc
    #@return [String]
    sevendigital_basic_property :type

    #Retrieves and populates all track properties
    #
    #useful with lazy loading turned off
    #@param [Hash] options optional hash of additional API parameters, e.g. image_size => 75, etc
    #@return [Track]
    def get_details(options={})
      track_with_details = @api_client.track.get_details_from_release(@id, @release.id, options)
      copy_basic_properties_from(track_with_details)
      self
    end

    #Title of the track stripped out of any version information if it's included the title of the track rather than version property
    #e.g. if title is "Some Song (Radio Edit)" it will return "Some Song"
    #@return [String]
    def short_title
  #   return title.gsub(/\s+[\(\[](album|lp|single|short|edit|radio)\s+version[\)\]]/ , "")
      return title.gsub(/\s+\(.*\s?(version|mix|remix|edit|edition|live|feat|explicit|original|remaster)\s?.*\)/i, "")
    end

    #Compares 2 songs whether they're just different versions of the same song by the same artist
    #e.g. track "Some Song (Radio Edit)" is alternate version of "Some Song (Remastered)"
    #returns true also if the 2 songs are the same
    #@return [Boolean]
    def alternate_version_of?(another_track)
      return another_track && short_title.downcase == another_track.short_title.downcase \
            && another_track.artist && artist.name.downcase == another_track.artist.name.downcase
    end

    #URL of mp3 preview for this track
    #@return [String]
    def preview_url(options={})
      @api_client.track.build_preview_url(@id, options)
    end

  end
end