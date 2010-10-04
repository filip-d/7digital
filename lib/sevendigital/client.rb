require 'ostruct'
require 'yaml'


module Sevendigital

  DEFAULT_CONFIGURATION = {
      :api_url =>  "api.7digital.com",
      :api_version => "1.2"
    }

  class Client

  def load_configuration_from_yml(file_name, environment=nil)
    plain_settings = YAML.load_file(file_name)
    if (plain_settings["common"] || (environment && plain_settings[environment])) then
      environment_settings = plain_settings["common"] || {}
      environment_settings.update(plain_settings[environment]) if environment
      environment_settings
    else
      plain_settings
    end
  end

  def load_configurations(configuration)
    
    default_settings = Sevendigital::DEFAULT_CONFIGURATION

    if (configuration.kind_of? String) then
      yml_configuration_file = configuration
    else
      yml_configuration_file ="#{RAILS_ROOT}/config/sevendigital.yml" if defined?(RAILS_ROOT)
      explicit_settings = configuration if configuration.kind_of? Hash
      explicit_settings = configuration.marshal_dump if configuration.kind_of? OpenStruct
    end

    environment = defined?(RAILS_ENV) ? RAILS_ENV  : nil
    yml_settings = load_configuration_from_yml(yml_configuration_file, environment) if yml_configuration_file
  
    settings = default_settings
    settings.update(yml_settings) if yml_settings
    settings.update(explicit_settings) if explicit_settings

    return OpenStruct.new(settings)
  end

  #Code here

    def initialize(configuration=nil, api_operator=nil)
      @configuration = load_configurations(configuration)
      @api_operator = api_operator || hire_api_operator
    end
  
    def hire_api_operator
       @configuration.cache ? ApiOperatorCached.new(self, @configuration.cache) : ApiOperator.new(self)
    end

    def artist
      @artist_manager ||= ArtistManager.new(self) 
    end

    def artist_digestor
      @artist_digestor ||= ArtistDigestor.new(self)
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
      @oauth_consumer ||= OAuth::Consumer.new( @configuration.oauth_consumer_key, @configuration.oauth_consumer_secret)
    end

    def oauth_request_token_digestor
      @oauth_request_token_digestor ||= OAuthTokenDigestor.new(self)
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
