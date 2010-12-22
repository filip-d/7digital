require "spec_helper"
require 'ostruct'

describe "ApiOperatorCached" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:verbose?).and_return(false)
    @client.stub!(:very_verbose?).and_return(false)
    @cache = stub(Hash)
    @cached_operator = Sevendigital::ApiOperatorCached.new(@client, @cache)
    @stub_api_request = stub_api_request()
  end

  it "should not look into cache if request requires signature" do
    @stub_api_request.stub!(:requires_signature?).and_return(true)
    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
    @cached_operator.should_receive(:make_http_request_and_digest).with(@stub_api_request).and_return(stub_api_response())
    @cached_operator.call_api(@stub_api_request)
  end

  it "should not make an http request if response already in cache " do
    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(stub_api_response())
    @cached_operator.should_not_receive(:make_http_request_and_digest)
    @cached_operator.call_api(@stub_api_request)
  end

  it "should make an http request if cached response is out of date " do
 
    expired_response = stub_api_response()
    expired_response.stub!(:out_of_date?).and_return(true)

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(expired_response)
    @cache.stub!(:set).and_return(nil)
    @cached_operator.should_receive(:make_http_request_and_digest)
    @cached_operator.call_api(@stub_api_request)
  end
  
  it "should make an http request if response not yet in cache and return the result " do
    api_response = stub_api_response()

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
    @cache.stub!(:set).and_return(nil)
    @cached_operator.should_receive(:make_http_request_and_digest).with(@stub_api_request).and_return(api_response)
    
    response = @cached_operator.call_api(@stub_api_request)
    response.should == api_response
  end

  it "should cache uncached api response if request was not signed" do
    api_response = stub_api_response()

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
   @cached_operator.stub!(:make_http_request_and_digest).and_return(api_response)

    @cache.should_receive(:set).with("key", api_response).and_return(nil)
    response = @cached_operator.call_api(@stub_api_request)
  end

  it "should not cache api response if request was signed" do
    api_response = stub_api_response()
    @stub_api_request.stub!(:requires_signature?).and_return(true)

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
    @cached_operator.stub!(:make_http_request_and_digest).and_return(api_response)

    @cache.should_not_receive(:set)
    response = @cached_operator.call_api(@stub_api_request)
  end

  def fake_http_response
    return Net::HTTP.new("1.1", 200, "response_body")
  end
  
  def stub_time(time)
    Time.stub!(:now).and_return(time)
  end

  def stub_api_response
    api_response = stub(Sevendigital::ApiResponse)
    api_response.stub!(:out_of_date?).and_return(false)
    api_response
  end

  def stub_api_request
  api_request = stub(Sevendigital::ApiRequest)

  api_request.stub!(:parameters).and_return({})
  api_request.stub!(:api_service).and_return(nil)
  api_request.stub!(:api_method).and_return("m")
  api_request.stub!(:requires_signature?).and_return(false)
  api_request.stub!(:requires_secure_connection?).and_return(false)
  api_request.stub!(:ensure_country_is_set)
  return api_request
end

end