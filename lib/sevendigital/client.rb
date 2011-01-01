module Sevendigital

  class Client

  COMMON_REQUEST_PARAMETERS = [:shop_id, :country, :page, :page_size, :image_size]

    def initialize(*args)
      @configuration = Sevendigital::ClientConfiguration.new(*args)
      yield @configuration if block_given?
      @api_operator = hire_api_operator
    end

    def default_parameters
      params = {}
      COMMON_REQUEST_PARAMETERS.each do |param|
        value = self.send(param)
        params[param] = value if value
      end
      params
    end
  
    def hire_api_operator
       @configuration.cache ? ApiOperatorCached.new(self, @configuration.cache) : ApiOperator.new(self)
    end

    def user_agent_info
      app_info = @configuration.app_name ? "/#{@configuration.app_name}" : nil
      app_info += " #{@configuration.app_version}" if app_info && @configuration.app_version
      "#{Sevendigital::NAME} Gem #{Sevendigital::VERSION}#{app_info}"
    end

    def create_api_request(api_method, parameters, options = {})
      parameters = options.merge(parameters)
      parameters = add_default_parameters(parameters)
      ApiRequest.new(api_method, parameters)
    end

    def make_api_request(api_method, parameters, options = {})
      api_request = create_api_request(api_method, parameters, options)
      operator.call_api(api_request)
    end

    def make_signed_api_request(api_method, parameters, options = {}, token = nil)
      api_request = create_api_request(api_method, parameters, options)
      api_request.require_signature
      api_request.require_secure_connection
      api_request.token = token

      operator.call_api(api_request)
    end

    def add_default_parameters(parameters)
      params = parameters
      default_parameters.each do |name, value|
        params[name] ||= value
      end
      params
    end

    def api_host_and_version(api_service=nil)
       service = api_service && !api_service.to_s.empty? ? "#{api_service}_" : ""
       return configuration.send("#{service}api_url".to_sym), configuration.send("#{service}api_version".to_sym)
    end

    def artist
      @artist_manager ||= ArtistManager.new(self) 
    end

    def artist_digestor
      @artist_digestor ||= ArtistDigestor.new(self)
    end

    def basket
      @basket_manager ||= BasketManager.new(self)
    end

    def basket_digestor
      @basket_digestor ||= BasketDigestor.new(self)
    end

    def basket_item_digestor
      @basket_item_digestor ||= BasketItemDigestor.new(self)
    end

    def download_url_digestor
      @download_url_digestor ||= DownloadUrlDigestor.new(self)
    end

    def format_digestor
      @format_digestor ||= FormatDigestor.new(self)
    end

    def label_digestor
      @label_digestor ||= LabelDigestor.new(self)
    end

    def locker_digestor
      @locker_digestor ||= LockerDigestor.new(self)
    end

    def locker_release_digestor
      @locker_release_digestor ||= LockerReleaseDigestor.new(self)
    end

    def locker_track_digestor
      @locker_track_digestor ||= LockerTrackDigestor.new(self)
    end

    def price_digestor
      @price_digestor ||= PriceDigestor.new(self)
    end

    def pager_digestor
      @pager_digestor ||= PagerDigestor.new(self)
    end

    def release
      @release_manager ||= ReleaseManager.new(self)
    end

    def release_digestor
      @release_digestor ||= ReleaseDigestor.new(self)
    end

    def track
      @track_manager ||= TrackManager.new(self)
    end

    def track_digestor
      @track_digestor ||= TrackDigestor.new(self)
    end

    def user
      @user_manager ||= UserManager.new(self)
    end

    def oauth
      @oauth_manager ||= OAuthManager.new(self)
    end

    def oauth_consumer
      host, version = api_host_and_version(:account)

      consumer_options = {
        :authorize_path     => "https://#{host}/#{version}/oauth/authorise",
        :http_method   => :get
      }

      @oauth_consumer ||= OAuth::Consumer.new( \
              @configuration.oauth_consumer_key, \
              @configuration.oauth_consumer_secret, \
              consumer_options \
      )
    end

    def oauth_request_token_digestor
      @oauth_request_token_digestor ||= OAuthRequestTokenDigestor.new(self)
    end

    def oauth_access_token_digestor
      @oauth_access_token_digestor ||= OAuthAccessTokenDigestor.new(self)
    end

    def api_response_digestor
      @api_response_digestor ||= ApiResponseDigestor.new(self)
    end
    
    def chart_item_digestor
      @chart_item_digestor ||= ChartItemDigestor.new(self)
    end
    
    def configuration
      return @configuration
    end

    def operator
      @api_operator
    end

    def country
      @country || @configuration.country
    end

    def country=(country_code)
      @country = country_code
    end

    def image_size
      @image_size || @configuration.image_size
    end

    def image_size=(size)
      @image_size = size
    end
  
    def page
      @page || @configuration.page
    end

    def page=(number)
      @page = number
    end

    def page_size
      @page_size || @configuration.page_size
    end

    def page_size=(size)
      @page_size = size
    end

    def shop_id
      @shop_id || @configuration.shop_id
    end

    def shop_id=(id)
      @shop_id = id
    end

    def verbose?
      !(@verbose || @configuration.verbose).nil?
    end

    def very_verbose?
      verbose? && (@verbose || @configuration.verbose).to_s == "very_verbose"
    end

    def verbose=(verbosity)
      @verbose = verbosity
    end

  end

end
