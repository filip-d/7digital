module Sevendigital

  class Artist < SevendigitalObject

    attr_accessor :id, :name, :appears_as

    sevendigital_basic_property :sort_name, :image, :url


    def get_details(options={})
      artist_with_details = @api_client.artist.get_details(@id, options)
      copy_basic_properties_from(artist_with_details)
    end

    sevendigital_extended_property :releases
    sevendigital_extended_property :top_tracks
    sevendigital_extended_property :similar

    def get_releases(options={})
     @api_client.artist.get_releases(@id, options)
    end

    def get_top_tracks(options={})
      @api_client.artist.get_top_tracks(@id, options)
    end

    def get_similar(options={})
      @similar = @api_client.artist.get_similar(@id, options)
    end

    def various?
      joined_names = "#{name} #{appears_as}".downcase

      various_variations = ["vario", "v???????????????rio", "v.a", "vaious", "varios" "vaious", "varoius", "variuos", \
                            "soundtrack", "karaoke", "original cast", "diverse artist"]
      various_variations.each{|various_variation| return true if joined_names.include?(various_variation)}
      return false
    end

        
  end
end