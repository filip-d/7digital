require File.join(File.dirname(__FILE__), %w[../spec_helper])
require 'time'

describe "ApiResponse" do

  it "should be ok if error code is 0 and content is not empty" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.content = '<xml></xml>'
    response.ok?.should == true

  end

  it "should not be ok if error code is not 0" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 5
    response.content = '<xml></xml>'
    response.ok?.should == false

    end

  it "should not be ok if response content is nil" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.ok?.should == false

  end

  it "should be serializable" do
    original_response = Sevendigital::ApiResponseDigestor.new(@client).from_xml\
      ("<response status='ok'><testElement id='123'>value</testElement></response>")
    original_response.error_code = 99
    original_response.headers = {"header" => "value"}


    tmp = Marshal.dump(original_response)
    restored_response = Marshal.load(tmp)

    restored_response.error_code.should == original_response.error_code
    restored_response.content.to_s.should == original_response.content.to_s
    restored_response.content.test_element.value.should == "value"
    restored_response.headers.should == original_response.headers

  end

  it "should be out of date if it's past its cache max age" do
    now = Time.now.utc
    yesterday = now - 24*60*60
    max_age = 12*60*60

    response = Sevendigital::ApiResponse.new
    response.headers = {"cache-control" => "private, max-age=#{max_age}", "Date" => yesterday.httpdate}

    response.out_of_date?(now).should == true

  end

  it "should be out of date if it's past its cache max age" do
    now = Time.now.utc
    yesterday = now - 24*60*60
    max_age = 12*60*60

    response = Sevendigital::ApiResponse.new
    response.headers = {"cache-control" => "private, max-age=#{max_age}", "Date" => yesterday.httpdate}

    response.out_of_date?(now).should == true

  end

  it "should not be out of date if it's within its cache max age" do
    now = Time.now.utc
    yesterday = now - 24*60*60
    max_age = 48*60*60
  #  stub_time(now)

    response = Sevendigital::ApiResponse.new
    response.headers = {"cache-control" => "private, max-age=#{max_age}", "Date" => yesterday.httpdate}

    response.out_of_date?(now).should == false

  end

  it "should be out of date if it is missing caching headers" do

    response = Sevendigital::ApiResponse.new
    response.out_of_date?(Time.now.utc).should == true

    response.headers = {"Date" => Time.now.utc.httpdate}
    response.out_of_date?(Time.now.utc).should == true

  end

  it "should be out of date if no max-age has been specified" do

    response = Sevendigital::ApiResponse.new
    response.headers = {"cache-control" => "no-cache", "Date" => Time.now.utc.httpdate}
    response.out_of_date?(Time.now.utc).should == true

  end

  it "should be out of date if it is missing Date header" do

    response = Sevendigital::ApiResponse.new
    response.out_of_date?(Time.now.utc).should == true

    response.headers = {"cache-control" => "private, max-age=#{2**30}"}
    response.out_of_date?(Time.now.utc).should == true
   
  end




end