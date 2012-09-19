# encoding: UTF-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

describe "CountryManager" do

  before do

    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @country_manager = Sevendigital::CountryManager.new(@client)

  end


  it "resolve should call country/resolve api method and digest the country code from response" do

    an_api_response = fake_api_response("country/resolve")
    a_country_code = 'XX'
    an_ip_address = '127.0.0.1'

    mock_client_digestor(@client, :country_digestor) \
        .should_receive(:from_xml_doc).with(an_api_response.item_xml("GeoIpLookup") ).and_return(a_country_code)

    @client.should_receive(:make_api_request) \
                   .with(:GET, "country/resolve", {:ipaddress => an_ip_address}, {}) \
                   .and_return(an_api_response)


    @country_manager.resolve(an_ip_address).should == a_country_code
  end


end
