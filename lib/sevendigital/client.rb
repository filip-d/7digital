module Sevendigital

  class Client

  #if default values for any of these parameters are set in configuration, they will be passed along with every single API request
  COMMON_REQUEST_PARAMETERS = [:shop_id, :country, :page, :page_size, :image_size]

    def initialize(*args)
      @configuration = Sevendigital::ClientConfiguration.new(*args)
      yield @configuration if block_given?
      @api_operator = hire_api_operator
    end

    def create_api_request(http_method, api_method, parameters, options = {})
      parameters = options.merge(parameters)
      parameters = add_default_parameters(parameters)
      ApiRequest.new(http_method, api_method, parameters)
    end

    def make_api_request(http_method, api_method, parameters, options = {})
      api_request = create_api_request(http_method, api_method, parameters, options)
      operator.call_api(api_request)
    end

    def make_signed_api_request(http_method, api_method, parameters, options = {}, token = nil)
      api_request = create_api_request(http_method, api_method, parameters, options)
      api_request.require_signature
      api_request.require_secure_connection
      api_request.token = token

      operator.call_api(api_request)
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

    def configuration
      return @configuration
    end

    def operator
      @api_operator
    end

    def verbose?
     !!(@verbose || @configuration.verbose)
    end

    def very_verbose?
      verbose? && (@verbose || @configuration.verbose).to_s == "very_verbose"
    end

  #@private
  def api_host_and_version(api_service=nil)
     service = api_service && !api_service.to_s.empty? ? "#{api_service}_" : ""
     return configuration.send("#{service}api_url".to_sym), configuration.send("#{service}api_version".to_sym)
  end

  #@private
  def user_agent_info
    app_info = @configuration.app_name ? "/#{@configuration.app_name}" : nil
    app_info += " #{@configuration.app_version}" if app_info && @configuration.app_version
    "#{Sevendigital::NAME} Gem #{Sevendigital::VERSION}#{app_info}"
  end

  private

    #@private
    def default_parameters
      params = {}
      COMMON_REQUEST_PARAMETERS.each do |param|
        value = @configuration.send(param)
        params[param] = value if value
      end
      params
    end

    #@private
    def hire_api_operator
       @configuration.cache ? ApiOperatorCached.new(self, @configuration.cache) : ApiOperator.new(self)
    end

    #@private
    def add_default_parameters(parameters)
      params = parameters
      default_parameters.each do |name, value|
        params[name] ||= value
      end
      params
    end


  end

end
