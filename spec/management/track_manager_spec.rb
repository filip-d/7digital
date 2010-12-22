# encoding: UTF-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

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

    @client.should_receive(:make_api_request) \
                 .with("track/details", {:trackId => a_track_id}, {}) \
                 .and_return(an_api_response)

    @track_manager.get_details(a_track_id).should == a_track

  end

  it "get_details_from_release should get all tracks from the release and pick the relevant one" do

    @client.stub!(:release).and_return(mock(Sevendigital::ReleaseManager))

    options = []
    track_1 = Sevendigital::Track.new(@client)
    track_1.id = 1
    track_2 = Sevendigital::Track.new(@client)
    track_2.id = 2
    a_track_list = [track_1, track_2]
    a_release_id = 123456

    @client.release.should_receive(:get_tracks).with(a_release_id, options).and_return(a_track_list)

    track = @track_manager.get_details_from_release(track_1.id, a_release_id, options)
    track.should == track_1
  end

  it "get_chart should call track/chart api method and digest the release list from response" do

    an_api_response = fake_api_response("track/chart")
    a_chart = []

    mock_client_digestor(@client, :chart_item_digestor) \
        .should_receive(:list_from_xml).with(an_api_response.content.chart).and_return(a_chart)

    @client.should_receive(:make_api_request) \
                   .with("track/chart", {}, {}) \
                   .and_return(an_api_response)


    chart = @track_manager.get_chart
    chart.should == a_chart
  end

  it "build_preview_url should return URL for track/preview api request" do
    track_id = 123456
    fake_preview_url = "http://7digital.com/track/preview"
    fake_api_request = stub(Sevendigital::ApiRequest)

    @client.should_receive(:create_api_request) \
                   .with("track/preview", {:trackId => track_id}, {}) \
                   .and_return(fake_api_request)

    @client.operator.should_receive(:create_request_uri) \
      .with(fake_api_request) \
      .and_return(fake_preview_url)

    preview_url = @track_manager.build_preview_url(track_id)

    preview_url.should == fake_preview_url
  end

  it "search should call track/search api method and digest the nested track list from response" do

    query = "radiohead"
    an_api_response = fake_api_response("track/search")
    a_track_list = [Sevendigital::Track.new(@client)]

    mock_client_digestor(@client, :track_digestor) \
      .should_receive(:nested_list_from_xml) \
      .with(an_api_response.content.search_results, :search_result, :search_results) \
      .and_return(a_track_list)

    @client.should_receive(:make_api_request) \
                   .with("track/search", {:q => query}, {}) \
                   .and_return(an_api_response)
    
    tracks = @track_manager.search(query)
    tracks.should == a_track_list

  end


end
