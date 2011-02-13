require "spec_helper"

describe "Client" do

  it "should not be verbose if not told anything" do
    client = Sevendigital::Client.new
    client.verbose?.should == false
    client.very_verbose?.should == false
  end

  it "should not be verbose if told to so" do
    client = Sevendigital::Client.new(:verbose => false)
    client.verbose?.should == false
    client.very_verbose?.should == false
  end

  it "should be verbose if told to be verbose in configuration" do
    client = Sevendigital::Client.new(:verbose => true)
    client.verbose?.should == true
    client.very_verbose?.should == false
  end

  it "should be very verbose if told to be very verbose in configruation" do
    client = Sevendigital::Client.new(:verbose => :very_verbose)
    client.verbose?.should == true
    client.very_verbose?.should == true
  end

  it "should be verbose if told so" do
    client = Sevendigital::Client.new(:verbose => false)
    client.configuration.verbose = true
    client.verbose?.should == true
    client.very_verbose?.should == false
  end

  it "should provide selected properties as default parameters for all api requests" do
    client = Sevendigital::Client.new(:page_size => 12345, :country => 'gb')
    client.configuration.country = 'sk'
    client.send(:default_parameters).should == {:page_size => 12345, :country => 'sk'}
  end

  it "create_api_request should merge method parameters and options with parameters taking preference" do
    client = Sevendigital::Client.new
    parameters = {:trackId => 1239, :releaseId => 456, :country => "CU"}
    options = {:page => 1, :country => "US",  :trackId => "SS"}
    request = client.create_api_request('method', parameters, options)
    request.parameters[:trackId].should == 1239
    request.parameters[:releaseId].should == 456
    request.parameters[:country].should == "CU"
    request.parameters[:page].should == 1
    puts request.parameters.inspect
    request.parameters.keys.size.should == 4 # page_size == null

  end

  it "create_api_request should add default parameters to request" do
    client = Sevendigital::Client.new
    client.configuration.page_size = 100
    client.configuration.shop_id = 200
    request = client.create_api_request('method', {}, {})

    request.parameters[:pageSize].should == 100;
    request.parameters[:shopId].should == 200;

  end

  it "should make an API call using API request created by the client itself " do
    a_method_name = "method"
    a_method_params = { :param1 => 1 }

    an_api_response = stub(Sevendigital::ApiResponse)
    an_api_request = stub(Sevendigital::ApiRequest)

    client = Sevendigital::Client.new
    mock_operator = mock(Sevendigital::ApiOperator)
    client.stub!(:operator).and_return(mock_operator)

    client.should_receive(:create_api_request).with(a_method_name, a_method_params, {}).and_return(an_api_request)

    mock_operator.should_receive(:call_api).with(an_api_request).and_return(an_api_response)

    response = client.make_api_request(a_method_name, a_method_params, {})

    response.should == an_api_response

  end

  it "should make a signed & secure API call" do
    a_method_name = "method"
    a_method_params = { :param1 => 1 }
    a_token = "token"

    an_api_response = "response"

    client = Sevendigital::Client.new
    mock_operator = mock(Sevendigital::ApiOperator)
    client.stub!(:operator).and_return(mock_operator)

    mock_operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == a_method_name
       api_request.requires_secure_connection?.should == true
       api_request.requires_signature?.should == true
       api_request.parameters.should  == a_method_params
       api_request.token.should == a_token
       an_api_response
    }

    response = client.make_signed_api_request(a_method_name, a_method_params, {}, a_token)

    response.should == an_api_response

  end

  it "should get API host url for specific API service from configuration" do

    client = Sevendigital::Client.new { |configuration|
      configuration.media_api_url = "media-base.api.url"
      configuration.media_api_version = "media-version"
    }

    client.api_host_and_version(:media).should == ["media-base.api.url", "media-version"]

  end

  it "should get API host url for standard API service from configuration" do

    client = Sevendigital::Client.new { |configuration|
      configuration.api_url = "base.api.url"
      configuration.api_version = "version"
    }

    client.send(:api_host_and_version).should == ["base.api.url", "version"]

  end

  it "should provide initialized oauth consumer" do

    configuration =  Sevendigital::ClientConfiguration.new
    configuration.oauth_consumer_key = "api_key"
    configuration.oauth_consumer_secret = "secret"
    configuration.account_api_url = "account.7d.com"
    configuration.account_api_version = "mobile"
    client = Sevendigital::Client.new(configuration)

    consumer = client.oauth_consumer
    consumer.authorize_path.should == "https://account.7d.com/mobile/oauth/authorise"
    consumer.key.should == "api_key"
    consumer.secret.should == "secret"

  end

  it "user_agent_info should contain app_name & version if specified" do
    client = Sevendigital::Client.new(:app_name => "RSpec", :app_version => "0.0.7")

    client.user_agent_info.should == "7digital Gem #{Sevendigital::VERSION}/RSpec 0.0.7"

  end


end