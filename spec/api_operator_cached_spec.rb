require "spec"
require 'sevendigital'
require 'ostruct'

describe "ApiOperatorCached" do

  before do
    @client = stub(Sevendigital::Client)
    @cache = stub(Hash)
    @cached_operator = Sevendigital::ApiOperatorCached.new(@client, @cache)
  end

  it "should not make an http request if response already in cache " do
    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(:something)
    @cached_operator.should_not_receive(:make_http_request_and_digest)
    @cached_operator.call_api(@stub_api_request)
  end
  
  it "should make an http request if response not yet in cache and return the result " do
    api_response = fake_api_response()

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
    @cache.stub!(:set).and_return(nil)
    @cached_operator.should_receive(:make_http_request_and_digest).with("key").and_return(api_response)
    
    response = @cached_operator.call_api(@stub_api_request)
    response.should == api_response
  end

  it "should cache uncached api response" do
    api_response = fake_api_response()

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
   @cached_operator.stub!(:make_http_request_and_digest).and_return(api_response)

    @cache.should_receive(:set).with("key", api_response).and_return(nil)
    response = @cached_operator.call_api(@stub_api_request)
  end

  def fake_api_response
    return Net::HTTP.new("1.1", 200, "response_body")
  end

end