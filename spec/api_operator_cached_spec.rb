require "spec_helper"
require 'ostruct'
require 'time'

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
    http_response = stub_http_response
    @stub_api_request.stub!(:requires_signature?).and_return(true)
    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.should_not_receive(:get)
    @cached_operator.should_receive(:make_http_request).with(@stub_api_request).and_return(http_response)
    @cached_operator.should_receive(:digest_http_response).with(http_response)
    @cached_operator.call_api(@stub_api_request)
  end

  it "should not cache api response if request was signed" do

    http_response = stub_http_response
    @stub_api_request.stub!(:requires_signature?).and_return(true)
    @cached_operator.stub(:create_request_uri).and_return("key")

    @cached_operator.stub!(:make_http_request).and_return(http_response)
    @cached_operator.stub!(:digest_http_response)
    @cache.should_not_receive(:set)
    @cached_operator.call_api(@stub_api_request)
  end

  it "should not make an http request if response already in cache and not out of date " do
    http_response = stub_http_response
    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(http_response)
    @cached_operator.stub!(:response_out_of_date?).with(http_response).and_return(false)
    @cached_operator.should_not_receive(:make_http_request)
    @cached_operator.should_not_receive(:digest_http_response).with(http_response)
    @cached_operator.call_api(@stub_api_request)
  end

  it "should make an http request if cached response is out of date " do

    expired_http_response = stub_http_response
    fresh_http_response = stub_http_response
    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(expired_http_response)
    @cached_operator.stub!(:response_out_of_date?).with(expired_http_response).and_return(true)

    @cache.stub!(:set).and_return(nil)
    @cached_operator.should_receive(:make_http_request).and_return(fresh_http_response)
    @cached_operator.should_receive(:digest_http_response).with(fresh_http_response)
    @cached_operator.call_api(@stub_api_request)
  end

  it "should make an http request if response not yet in cache, digest it and return the result " do
    api_response = stub_api_response()
    http_response = fake_http_response()

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
    @cache.stub!(:set).and_return(nil)
    @cached_operator.should_receive(:make_http_request).with(@stub_api_request).and_return(http_response)
    @cached_operator.should_receive(:digest_http_response).with(http_response).and_return(api_response)

    response = @cached_operator.call_api(@stub_api_request)
    response.should == api_response
  end

  it "should cache uncached api response if request was not signed" do
    http_response = stub_http_response()
    api_response = stub_api_response()

    @cached_operator.stub(:create_request_uri).and_return("key")
    @cache.stub!(:get).with("key").and_return(nil)
    @cached_operator.stub!(:make_http_request).and_return(http_response)
    @cached_operator.stub!(:digest_http_response).with(http_response).and_return(api_response)

    @cache.should_receive(:set).with("key", api_response).and_return(nil)
    @cached_operator.call_api(@stub_api_request)
  end

  it "response should be out of date if it's past its cache max age" do
    now = Time.now.utc
    yesterday = now - 24*60*60
    max_age = 12*60*60

    http_response = stub_http_response
    http_response.stub!(:headers).and_return({
      "cache-control" => "private, max-age=#{max_age}",
      "Date" => yesterday.httpdate
    })

    @cached_operator.response_out_of_date?(http_response, now).should == true

  end


  it "response should not be out of date if it's within its cache max age" do
    now = Time.now.utc
    yesterday = now - 24*60*60
    max_age = 48*60*60

    http_response = stub_http_response
    http_response.stub!(:headers).and_return({
      "cache-control" => "private, max-age=#{max_age}",
      "Date" => yesterday.httpdate
    })

    @cached_operator.response_out_of_date?(http_response, now).should == false

  end

  it "response should be out of date if it is missing caching headers" do

    http_response = stub_http_response
    http_response.stub!(:headers).and_return({})
    @cached_operator.response_out_of_date?(http_response, Time.now.utc).should == true

    http_response.stub!(:headers).and_return({
      "Date" => Time.now.utc.httpdate
    })
    @cached_operator.response_out_of_date?(http_response, Time.now.utc).should == true

  end

  it "response should be out of date if no max-age has been specified" do

    http_response = stub_http_response
    http_response.stub!(:headers).and_return({"cache-control" => "no-cache", "Date" => Time.now.utc.httpdate})
    @cached_operator.response_out_of_date?(http_response, Time.now.utc).should == true

  end

  it "response should be out of date if it is missing Date header" do

    http_response = stub_http_response
    http_response.stub!(:headers).and_return({"cache-control" => "private, max-age=#{2**30}"})
    @cached_operator.response_out_of_date?(http_response, Time.now.utc).should == true
    
  end


  def fake_http_response
    return Net::HTTP.new("1.1", 200, "response_body")
  end
  
  def stub_http_response
    stub(Net::HTTP)
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