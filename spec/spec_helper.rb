#$: << 'sevendigital'
#$: << 'spec'

=begin
require 'simplecov'
SimpleCov.start do
  add_group 'Management', 'lib/sevendigital/management'
  add_group 'Digestion', 'lib/sevendigital/digestion_tract'
  add_group 'Model', 'lib/sevendigital/model'
end
=end

require 'rspec'
require File.expand_path(
    File.join(File.dirname(__FILE__), %w[.. lib sevendigital]))

Rspec.configure do |config|
  # == Mock Framework 
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

  alias running lambda

  VALID_7DIGITAL_URL = /http\:\/\/.+7digital\..+partner=[\d]+/
  VALID_7DIGITAL_IMAGE = /http\:\/\/.+/

  def load_sample_method_xml(method_name)
    method_name = "test-xml/methods/" + method_name + ".xml"
      IO.read( File.join(File.dirname(__FILE__), method_name.split('/')))
  end

  def load_sample_object_xml(method_name)
    method_name = "test-xml/objects/" + method_name + ".xml"
    IO.read( File.join(File.dirname(__FILE__), method_name.split('/')))
  end

  def fake_api_response(method_name)
    response = Sevendigital::ApiResponse.new
    response.content = load_sample_method_xml(method_name)
    response.stub(:ok?).and_return true
#    Sevendigital::ApiResponseDigestor.new(nil).from_xml_string(load_sample_method_xml(method_name))
  response
  end

  def fake_api_error_response(code)
    Sevendigital::ApiResponseDigestor.new(nil).from_xml_string("<response status=\"error\"><error code=\"#{code}\"></error></response>")
  end

  def mock_client_digestor(client, digestor_class)
    digestor = mock(Sevendigital.const_get(camelize(digestor_class.to_s)))
    client.stub!(digestor_class).and_return(digestor)
    digestor
  end

  def camelize(str)
    str.split('_').map {|w| w.capitalize}.join
  end

  def stub_api_client(configuration, response_digestor=nil)
    @client = stub(Sevendigital::Client)
    @client.stub!(:configuration).and_return(configuration)
    @client.stub!(:oauth_consumer).and_return(OAuth::Consumer.new( configuration.oauth_consumer_key, configuration.oauth_consumer_secret))
    @client.stub!(:api_response_digestor).and_return(response_digestor)
    @client.stub!(:default_parameters).and_return({:country => 'sk'})
    @client.stub!(:user_agent_info).and_return("7digital")
    @client.stub!(:verbose?).and_return(false)
    @client.stub!(:very_verbose?).and_return(false)
    @client.stub!(:api_host_and_version).and_return(["base.api.url","version"])
    @client.stub!(:log).and_yield()
    @client
  end

  def test_configuration
    configuration = OpenStruct.new
    configuration.oauth_consumer_key = "oauth_consumer_key"
    configuration
  end


