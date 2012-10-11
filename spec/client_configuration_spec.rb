require "spec_helper"

describe "ClientConfiguration" do

  it "should initialize with default configuration" do
    configuration = Sevendigital::ClientConfiguration.new
    configuration.api_url.should == 'api.7digital.com'
    configuration.api_version.should == '1.2'
    configuration.media_api_url.should == 'media-eu.7digital.com'
    configuration.media_api_version.should == 'media'
    configuration.account_api_url.should == 'account.7digital.com'
    configuration.account_api_version.should == 'web'
  end

  it "should initialize using hash" do
    configuration = Sevendigital::ClientConfiguration.new(:api_url => "test-hash.7digital.com")
    configuration.api_url.should == 'test-hash.7digital.com'
  end

  it "should initialize using OpenStruct object" do
    configuration = Sevendigital::ClientConfiguration.new(OpenStruct.new(:api_url => "test-openstruct.7digital.com"))
    configuration.api_url.should == 'test-openstruct.7digital.com'
  end

  it "should initialize using simple YAML file" do
    configuration = Sevendigital::ClientConfiguration.new(File.join(File.dirname(__FILE__),"data", "configuration_override.yml"))
    configuration.api_url.should == 'test-yml-simple.7digital.com'
  end

  it "should initialize mixing configuration file name and explicit hash override" do
   conf_file = File.join(File.dirname(__FILE__),"data", "configuration_override.yml")
   configuration = Sevendigital::ClientConfiguration.new(conf_file, :api_url => 'hash-override')
   configuration.api_url.should == 'hash-override'
   configuration.api_version.should == 'yml-simple'
  end

  it "should initialize mixing hash settings and configuration file override" do
    conf_file = File.join(File.dirname(__FILE__),"data", "configuration_override.yml")
    configuration = Sevendigital::ClientConfiguration.new({:api_url => 'hash-override', :xxx => 'yyy'}, conf_file)
    configuration.api_url.should == 'test-yml-simple.7digital.com'
    configuration.xxx.should == 'yyy'
  end
  
  it "should initialize mixing 2 explicit hash overrides" do
    configuration = Sevendigital::ClientConfiguration.new( {:api_url => 'v1', :a => 'x'}, {:api_url => 'v2', :b => 'y'})
    configuration.api_url.should == 'v2'
    configuration.a.should == 'x'
    configuration.b.should == 'y'
  end

  it "should use environment specific configuration file" do
    conf_file = File.join(File.dirname(__FILE__),"data", "configuration_env_override.yml")
    configuration = Sevendigital::ClientConfiguration.new(conf_file)
    configuration.api_url.should == 'test-yml-common.7digital.com'
  end

  it "should use environment specific configuration file with environment specific settings" do
    conf_file = File.join(File.dirname(__FILE__),"data", "configuration_env_override.yml")
    
    rails = OpenStruct.new
    rails.env = "development"
    Object.const_set(:Rails, rails)

    configuration = Sevendigital::ClientConfiguration.new(conf_file)
    configuration.api_url.should == 'test-yml-development.7digital.com'
    Object.instance_eval{ remove_const :Rails }
  end

  it "should use rails/config/sevendigital configuration as default rails settings" do
    rails = OpenStruct.new
    rails.root = Pathname(File.join(File.dirname(__FILE__),"data"))
    Object.const_set(:Rails, rails)

    configuration = Sevendigital::ClientConfiguration.new()
    configuration.api_url.should == 'test-yml-rails-common.7digital.com'
    Object.instance_eval{ remove_const :Rails }
  end

end