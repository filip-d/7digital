module Sevendigital

#with lazy loading enabled these will be automatically populated by calling get_details
  #==Extended properties
  #with lazy loading enabled these will be automatically populated by calling the method in brackets
  #additional options can be passed in when accessing lazy loaded properties, e.g.
  #   artist.releases({:page_size => 5, :image_size =>250})

class Artist < SevendigitalObject

  #7digital artist ID
  #@return [Integer]
  attr_accessor :id

  #artist's name
  #@return [String]
  attr_accessor :name

  #Artist's name as it appears on the release or track (only available when artist is linked from release or track)
  #@return [String]
  attr_accessor :appears_as

  #Artist name used for sorting, e.g. Beatles, The (optional lazy-loaded property)
  #@return [String]
  sevendigital_basic_property :sort_name

  #Artist image URL (optional lazy-loaded property)
  #@return [String]
  sevendigital_basic_property :image

  #Artist buy link URL (optional lazy-loaded property)
  #@return [String]
  sevendigital_basic_property :url

  #popularity of the artist (lazy loaded using #get_tags)
  #@return [decimal] similar
  sevendigital_basic_property :popularity

  #artist's releases (lazy loaded using get_releases)
  #@return [Array<Release>] 
  sevendigital_extended_property :releases

  #artist's top tracks (lazy loaded using get_top_tracks)
  #@return [Array<Track>] 
  sevendigital_extended_property :top_tracks

  #list of artists similar to this artist (lazy loaded using {#get_similar})
  #@return [Array<Artist>] similar
  sevendigital_extended_property :similar

  #list of tags associated with the artist (lazy loaded using #get_tags)
  #@return [Array<Artist>] similar
  sevendigital_extended_property :tags

    #populates all available details on artist by calling *artist/details* API method
    #@return [Artist] 
    def get_details(options={})
      artist_with_details = @api_client.artist.get_details(@id, options)
      copy_basic_properties_from(artist_with_details)
    end

    #releases by this artist retrieved by calling *artist/releases* API method
    #@return [Array<Release>]
    def get_releases(options={})
      @api_client.artist.get_releases(@id, options)
    end

    #top tracks by this artist retrieved by calling *artist/topTracks* API method
    #@return [Array<Track>] 
    def get_top_tracks(options={})
      @api_client.artist.get_top_tracks(@id, options)
    end

    #artists similar to this artist retrieved by calling *artist/similar* API method
    #@return [Array<Track>]
    def get_similar(options={})
      @similar = @api_client.artist.get_similar(@id, options)
    end

    #tags associated with this artist retrieved by calling *artist/tags* API method
    #@return [Array<Tag>]
    def get_tags(options={})
      @api_client.artist.get_tags(@id, options)
    end

    #does this artist represents various artists?
    #@return [Boolean]
    def various?
      joined_names = "#{name} #{appears_as}".downcase

      various_variations = ["vario", "v???????????????rio", "v.a", "vaious", "varios" "vaious", "varoius", "variuos", \
                            "soundtrack", "karaoke", "original cast", "diverse artist"]
      various_variations.each{|various_variation| return true if joined_names.include?(various_variation)}
      return false
    end

        
  end
end