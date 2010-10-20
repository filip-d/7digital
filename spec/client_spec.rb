require File.join(File.dirname(__FILE__), %w[spec_helper])

describe "Client" do

  it "should load default configuration" do
    client = Sevendigital::Client.new
    client.configuration.api_url.should == 'api.7digital.com'
    client.configuration.api_version.should == '1.2'
    client.configuration.media_api_url.should == 'media-eu.7digital.com'
    client.configuration.media_api_version.should == 'media'
    client.configuration.account_api_url.should == 'account.7digital.com'
    client.configuration.account_api_version.should == 'web'
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

  it "should not be verbose if not told to so" do
    configuration = OpenStruct.new
    client = Sevendigital::Client.new(configuration)
    client.verbose?.should == false
    client.very_verbose?.should == false
  end

  it "should be verbose if told to be verbose in configuration" do
    configuration = OpenStruct.new
    configuration.verbose = true
    client = Sevendigital::Client.new(configuration)
    client.verbose?.should == true
    client.very_verbose?.should == false
  end

  it "should be very verbose if told to be very verbose in configruation" do
    configuration = OpenStruct.new
    configuration.verbose = :very_verbose
    client = Sevendigital::Client.new(configuration)
    client.verbose?.should == true
    client.very_verbose?.should == true
  end

    it "should be verbose if told so" do
    configuration = OpenStruct.new
    configuration.verbose = false
    client = Sevendigital::Client.new(configuration)
    client.verbose = true
    client.verbose?.should == true
    client.very_verbose?.should == false
  end

end