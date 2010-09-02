require "spec"
require 'sevendigital'
require 'ostruct'

describe "ApiOperator" do

  before do
    response_digestor = stub(Sevendigital::ApiResponseDigestor)
    response_digestor.stub!(:from_http_response).and_return(fake_digested_response)

    stub_api_client(test_configuration, response_digestor)

    Net::HTTP.stub!(:get_response).and_return(fake_api_response)

    @api_operator = Sevendigital::ApiOperator.new(@client)

    @stub_api_request = stub_api_request()

  end

  it "should create request URI based on api method and client configuration" do

    api_request = Sevendigital::ApiRequest.new("api/method", {:param1 => "value", :paramTwo => 2})

    uri = @api_operator.create_request_uri(api_request)

    uri.kind_of?(URI).should == true
    uri.to_s.should == "http://base.api.url/version/api/method?oauth_consumer_key=oauth_consumer_key&param1=value&paramTwo=2"

  end

  it "should make sure country is set before making request" do
    @client.stub!(:country).and_return("sk")

    @stub_api_request.should_receive(:ensure_country_is_set).with("sk")
    
    @api_operator.call_api(@stub_api_request)

  end

  it "should make HTTP request and get response" do

    Net::HTTP.should_receive(:get_response).with(@api_operator.create_request_uri(@stub_api_request))

    @api_operator.call_api(@stub_api_request)

  end

  it "should digest the HTTP response and get it out" do

    http_response = fake_api_response

    Net::HTTP.stub!(:get_response).and_return(http_response)

    @client.api_response_digestor.should_receive(:from_http_response).with(http_response).and_return(fake_digested_response)

    response = @api_operator.call_api(@stub_api_request)

    response.kind_of?(Peachy::Proxy).should == true
    response.to_s.should == fake_digested_response.to_s

  end

  def test_configuration
    configuration = OpenStruct.new
    configuration.api_url = "base.api.url"
    configuration.api_version = "version"
    configuration.oauth_consumer_key = "oauth_consumer_key"
    return configuration
  end

  def fake_api_response
    return Net::HTTP.new("1.1", 200, "response_body")
  end

  def fake_digested_response
    return Peachy::Proxy.new("<response><content>test</content></response>")
  end

  def stub_api_client(configuration, response_digestor)
  @client = stub(Sevendigital::Client)
  @client.stub!(:configuration).and_return(configuration)
  @client.stub!(:api_response_digestor).and_return(response_digestor)
  @client.stub!(:country).and_return("sk")
end

def stub_api_request
  api_request = stub(Sevendigital::ApiRequest)

  api_request.stub!(:parameters).and_return({})
  api_request.stub!(:api_method).and_return("m")
  api_request.stub!(:ensure_country_is_set)
  return api_request
end

end