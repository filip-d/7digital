module Sevendigital

  #==Basic properties
  #<tt>*id*</tt>:: \Artist ID
  #<tt>*name*</tt>:: \Artist\'s name
  #<tt>*appears_as*</tt>:: \Artist\'s name as it appears on the release or track (only available when artist is linked from release or track)
  #
  #==Optional properties
  #with lazy loading enabled these will be automatically populated by calling get_details
  #<tt>*sort_name*</tt>:: \Artist name used for sorting, e.g. Beatles, The
  #<tt>*image*</tt>:: \Artist image URL
  #<tt>*url*</tt>:: \Artist buy link URL
  #
  #==Extended properties
  #with lazy loading enabled these will be automatically populated by calling the method in brackets
  #<tt>*releases*</tt>:: array of artist\'s releases (retrieved using get_releases)
  #<tt>*top_tracks*</tt>:: array of artist\'s top tracks (get_top_tracks)
  #<tt>*similar*</tt>:: array of artists similar to this artist (get_similar)
  #additional options can be passed in when accessing lazy loaded properties, e.g.
  #   artist.releases({:page_size => 5, :image_size =>250})

  class Artist < SevendigitalObject

    attr_accessor :id, :name, :appears_as #:nodoc:

    sevendigital_basic_property :sort_name, :image, :url

    #Retrieves artist\'s details by calling *artist/details* API method
    def get_details(options={})
      artist_with_details = @api_client.artist.get_details(@id, options)
      copy_basic_properties_from(artist_with_details)
    end

    sevendigital_extended_property :releases
    sevendigital_extended_property :top_tracks
    sevendigital_extended_property :similar
    sevendigital_extended_property :tags

    #Retrieves releases by this artist by calling *artist/releases* API method
    def get_releases(options={})
    @api_client.artist.get_releases(@id, options)
    end

    #Retrieves top tracks by this artist by calling *artist/topTracks* API method
    def get_top_tracks(options={})
    @api_client.artist.get_top_tracks(@id, options)
    end

    #Retrieves artists similar to this artist by calling *artist/similar* API method
    def get_similar(options={})
      @similar = @api_client.artist.get_similar(@id, options)
    end

    #Retrieves tags of this artist by calling *artist/tags* API method
    def get_tags(options={})
    @api_client.artist.get_tags(@id, options)
    end

    #True if this artist represents various artists
    def various?
      joined_names = "#{name} #{appears_as}".downcase

      various_variations = ["vario", "v???????????????rio", "v.a", "vaious", "varios" "vaious", "varoius", "variuos", \
                            "soundtrack", "karaoke", "original cast", "diverse artist"]
      various_variations.each{|various_variation| return true if joined_names.include?(various_variation)}
      return false
    end

        
  end
end