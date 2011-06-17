module Sevendigital

  class Release < SevendigitalObject

    attr_accessor :id, :title

    sevendigital_basic_property  :version, :type, :artist, :image, :url, :release_date,
                      :added_date, :barcode, :year, :explicit_content, :formats, :label
                         
    sevendigital_extended_property :tracks
    sevendigital_extended_property :recommendations
    sevendigital_extended_property :tags

    def get_details(options={})
      release_with_details = @api_client.release.get_details(@id, options)
      copy_basic_properties_from(release_with_details)
      @price = release_with_details.instance_variable_get("@price")
      release_with_details
    end
    
    def get_tracks(options={})
      @api_client.release.get_tracks(@id, options)
    end

    def get_recommendations(options={})
      @api_client.release.get_recommendations(@id, options)
    end

    def get_tags(options={})
      @api_client.release.get_tags(@id, options)
     end

    def demand_price(options={})
      get_details(options) if @price.nil? || @price.value.nil?
    end

    def price(options={})
      begin
        demand_price(options) if @api_client.configuration.lazy_load
      rescue Sevendigital::SevendigitalError => error
        @api_client.log(:verbose) { "Release: Error while lazyloading price - #{error.error_code} #{error.error_message}" }
        raise error if !@api_client.configuration.ignorant_lazy_load
      end
      @price
    end

    def price=(value)
      @price = value
    end

  end
  
end