require "peachy"
require "will_paginate"

module Sevendigital

  class Release < SevendigitalObject

    attr_accessor :id, :title

    sevendigital_basic_property  :version, :type, :artist, :image, :url, :release_date,
                      :added_date, :barcode, :year, :explicit_content, :formats, :label, :price
                         
    sevendigital_extended_property :tracks
    sevendigital_extended_property :recommendations

    def get_details(options={})
      release_with_details = @api_client.release.get_details(@id, options)
      copy_basic_properties_from(release_with_details)
    end
    
    def get_tracks(options={})
      @tracks = @api_client.release.get_tracks(@id, options).collect do |track|
        track.release = self
        track
      end
    end

    def get_recommendations(options={})
      @recommendations = @api_client.release.get_recommendations(@id, options)
    end

  end
  
end