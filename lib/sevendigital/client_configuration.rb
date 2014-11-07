require 'ostruct'
require 'yaml'

module Sevendigital

  DEFAULT_CONFIGURATION = {
      :api_url =>  "api.7digital.com",
      :api_version => "1.2",
      :media_api_url =>  "stream.svc.7digital.net",
      :media_api_version => "",
      :previews_api_url =>  "previews.7digital.com",
      :previews_api_version => "",
      :account_api_url =>  "account.7digital.com",
      :account_api_version => "web"
    }.freeze
  
  class ClientConfiguration < OpenStruct

    def initialize(*args)

      super()

      self.override_with(Sevendigital::DEFAULT_CONFIGURATION)

      self.override_with(default_configuration_file)

      args.each do |configuration_argument|
        self.override_with(configuration_argument)
      end
      #puts "Now: #{self.inspect}"
  
    end

    def override_with(configuration)
      #puts "Now: #{self.inspect}"
      #puts "Overriding with #{configuration.class}: #{configuration.inspect}"
      return self unless configuration
      if configuration.kind_of? Hash then
        table.merge!(configuration)
        return self
      end
      if configuration.kind_of? OpenStruct then
        table.merge!(configuration.marshal_dump)
        return self
      end
      if (configuration.kind_of? String) && is_it_yml_file?(configuration) then
        table.merge!(load_configuration_from_yml(configuration, current_environment))
        return self
      end

    end
    
    def default_configuration_file
      return nil unless defined?(Rails.root)
      Rails.root.join('config', 'sevendigital.yml').to_s
    end

    def current_environment
      defined?(Rails.env) ? Rails.env  : nil
    end

    def load_configuration_from_yml(file_name, environment=nil)
      plain_settings = transform_keys_to_symbols(YAML.load_file(file_name))
      if (plain_settings[:common] || (environment && plain_settings[environment.to_sym])) then
        environment_settings = plain_settings[:common] || {}
        environment_settings.update(plain_settings[environment.to_sym]) if environment
        environment_settings
      else
        plain_settings
      end
    end

    private

    def is_it_yml_file?(file_name)
      file_name.include?('.yml')
    end

    def transform_keys_to_symbols(hash)
      return hash if not hash.is_a?(Hash)
      new_hash = hash.inject({}){|memo,(k,v)| memo[k.to_sym] = transform_keys_to_symbols(v); memo}
      new_hash
    end
  end
end
