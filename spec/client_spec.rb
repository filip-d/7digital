require "spec"
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe "Client" do

  it "should load default configuration" do
    client = Sevendigital::Client.new
    client.configuration.api_url.should == 'api.7digital.com'
  end

  it "should override default configuration with configuration hash" do
    client = Sevendigital::Client.new(:api_url => "test-hash.7digital.com")
    client.configuration.api_url.should == 'test-hash.7digital.com'
  end

  it "should override default configuration with configuration class" do
    client = Sevendigital::Client.new(OpenStruct.new(:api_url => "test-openstruct.7digital.com"))
    client.configuration.api_url.should == 'test-openstruct.7digital.com'
  end

  it "should use simple configuration file" do
    client = Sevendigital::Client.new(File.join(File.dirname(__FILE__),"data", "configuration_override.yml"))
    client.configuration.api_url.should == 'test-yml-simple.7digital.com'
  end

  it "should use environment specific configuration file" do
    client = Sevendigital::Client.new(File.join(File.dirname(__FILE__),"data", "configuration_env_override.yml"))
    client.configuration.api_url.should == 'test-yml-common.7digital.com'
  end

  it "should use environment specific configuration file with environment specific settings" do
    Object.const_set(:RAILS_ENV, "development") 
    client = Sevendigital::Client.new(File.join(File.dirname(__FILE__),"data", "configuration_env_override.yml"))
    client.configuration.api_url.should == 'test-yml-development.7digital.com'
    Object.instance_eval{ remove_const :RAILS_ENV }
  end

  it "should use rails/config/sevendigital configuration as default rails settings" do
    Object.const_set(:RAILS_ROOT, File.join(File.dirname(__FILE__),"data"))
    client = Sevendigital::Client.new()
    client.configuration.api_url.should == 'test-yml-rails-common.7digital.com'
    Object.instance_eval{ remove_const :RAILS_ROOT }
  end

end