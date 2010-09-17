# encoding: UTF-8
require 'spec'
require 'date'
require 'sevendigital'

describe "TrackManager" do

  before do

    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @track_manager = Sevendigital::TrackManager.new(@client)

  end

  it "get_details should call track/details api method and return digested track" do
    a_track_id = 123
    an_api_response = fake_api_response("track/details")
    a_track = Sevendigital::Track.new(@client)

    mock_client_digestor(@client, :track_digestor) \
      .should_receive(:from_xml).with(an_api_response.content.track).and_return(a_track)

    @client.operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == "track/details"
       api_request.parameters[:trackId].should  == a_track_id
       an_api_response
    }

    @track_manager.get_details(a_track_id).should == a_track

  end

  it "get_chart should call track/chart api method and digest the release list from response" do

    api_response = fake_api_response("track/chart")
    a_chart = []

    mock_client_digestor(@client, :chart_item_digestor) \
        .should_receive(:list_from_xml).with(api_response.content.chart).and_return(a_chart)

    @client.operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == "track/chart"
       api_response
    }

    chart = @track_manager.get_chart
    chart.should == a_chart
  end

  it "build_preview_url should return URL for track/preview api request" do
    track_id = 123456
    fake_preview_url = "http://7digital.com/track/preview"

    @client.operator.should_receive(:create_request_uri) { |api_request|
       api_request.api_method.should == "track/preview"
       api_request.parameters[:trackId].should  == track_id
       fake_preview_url
    }

    preview_url = @track_manager.build_preview_url(track_id)

    preview_url.should == fake_preview_url
  end


end
