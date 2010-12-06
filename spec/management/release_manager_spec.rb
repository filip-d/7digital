# encoding: UTF-8
require 'date'
require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "ReleaseManager" do

  before do

    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @release_manager = Sevendigital::ReleaseManager.new(@client)

  end

  it "should get release by release id" do
    expected_release_id = 123
    api_response = fake_api_response("release/details")
    a_release = Sevendigital::Release.new(@client)

    mock_client_digestor(@client, :release_digestor) \
      .should_receive(:from_xml).with(api_response.content.release).and_return(a_release)

    @client.should_receive(:make_api_request) \
      .with("release/details", {:releaseId => expected_release_id}, {}) \
      .and_return(api_response)

    @release_manager.get_details(expected_release_id).should == a_release

  end

  it "get_tracks should call release/tracks api method and digest the track list from response" do
    expected_options = {:page_size => 20}
    a_release_id = 123
    api_response = fake_api_response("release/tracks")
    a_track_list = []

    mock_client_digestor(@client, :track_digestor) \
      .should_receive(:list_from_xml).with(api_response.content.tracks).and_return(a_track_list)

    @client.should_receive(:make_api_request) \
      .with("release/tracks", {:releaseId=>a_release_id}, expected_options) \
      .and_return(api_response)

    tracks = @release_manager.get_tracks(a_release_id, expected_options)
    tracks.should == a_track_list

  end

  it "get_tracks should call use page size 100 by default" do

    a_release_id = 123
    api_response = fake_api_response("release/tracks")
    a_track_list = []

    mock_client_digestor(@client, :track_digestor) \
      .should_receive(:list_from_xml).with(api_response.content.tracks).and_return(a_track_list)

    @client.should_receive(:make_api_request) \
      .with("release/tracks", {:releaseId => a_release_id}, {:page_size => 100}) \
      .and_return(api_response)

    tracks = @release_manager.get_tracks(a_release_id)
    tracks.should == a_track_list

  end


  it "get_chart should call release/chart api method and digest the release list from response" do

    api_response = fake_api_response("release/chart")
    a_chart = []

    mock_client_digestor(@client, :chart_item_digestor) \
        .should_receive(:list_from_xml).with(api_response.content.chart).and_return(a_chart)

    @client.should_receive(:make_api_request) \
      .with("release/chart", {}, {}) \
      .and_return(api_response)

    chart = @release_manager.get_chart
    chart.should == a_chart
  end

  it "get_by_date should call release/byDate with supplied parameters and digest the release list from response" do

    from_date = DateTime.new(2010, 01, 01)
    to_date = DateTime.new(2010, 05, 01)
    api_response = fake_api_response("release/bydate")
    a_release_list = []

    mock_client_digestor(@client, :release_digestor) \
      .should_receive(:list_from_xml).with(api_response.content.releases).and_return(a_release_list)

    @client.should_receive(:make_api_request) \
         .with("release/byDate", {:fromDate => from_date.strftime("%Y%m%d"), :toDate => to_date.strftime("%Y%m%d")}, {}) \
         .and_return(api_response)

    tracks = @release_manager.get_by_date(from_date, to_date)
    tracks.should == a_release_list

  end

  it "get_by_date should call release/tracks with no parameters and digest the release list from response" do

    api_response = fake_api_response("release/bydate")
    a_release_list = []

    mock_client_digestor(@client, :release_digestor) \
      .should_receive(:list_from_xml).with(api_response.content.releases).and_return(a_release_list)

    @client.should_receive(:make_api_request) \
         .with("release/byDate", {}, {}) \
         .and_return(api_response)

    releases = @release_manager.get_by_date
    releases.should == a_release_list

  end

  it "get_recommendations should call release/recommend api method and digest the nested release list from response" do

    a_release_id = 123
    api_response = fake_api_response("release/recommend")
    a_release_list = []

    mock_client_digestor(@client, :release_digestor) \
      .should_receive(:nested_list_from_xml) \
      .with(api_response.content.recommendations, :recommended_item, :recommendations) \
      .and_return(a_release_list)

    @client.should_receive(:make_api_request) \
         .with("release/recommend", {:releaseId => a_release_id}, {}) \
         .and_return(api_response)
   
    releases = @release_manager.get_recommendations(a_release_id)
    releases.should == a_release_list

  end

    it "get_top_by_tag should call release/byTag/top api method and digest the nested release list from response" do

    tags = "alternative-indie"
    api_response = fake_api_response("release/byTag/top")
    a_release_list = []

    mock_client_digestor(@client, :release_digestor) \
      .should_receive(:nested_list_from_xml) \
      .with(api_response.content.tagged_results, :tagged_item, :tagged_results) \
      .and_return(a_release_list)

    @client.should_receive(:make_api_request) \
         .with("release/byTag/top", {:tags => tags}, {}) \
         .and_return(api_response)
    
    releases = @release_manager.get_top_by_tag(tags)
    releases.should == a_release_list

    end

    it "search should call release/search api method and digest the nested release list from response" do

      query = "radiohead"
      api_response = fake_api_response("release/search")
      a_release_list = []

      mock_client_digestor(@client, :release_digestor) \
        .should_receive(:nested_list_from_xml) \
        .with(api_response.content.search_results, :search_result, :search_results) \
        .and_return(a_release_list)

      @client.should_receive(:make_api_request) \
           .with("release/search", {:q => query}, {}) \
           .and_return(api_response)

      releases = @release_manager.search(query)
      releases.should == a_release_list

    end


end
