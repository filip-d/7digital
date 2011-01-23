# encoding: UTF-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

describe "TagManager" do

  before do

    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @tag_manager = Sevendigital::TagManager.new(@client)

  end


  it "get_tag_list should call tag api method and digest the tag list from response" do

    an_api_response = fake_api_response("tag/index")
    a_tag_list = [Sevendigital::Tag.new]

    mock_client_digestor(@client, :tag_digestor) \
        .should_receive(:list_from_xml).with(an_api_response.content.tags).and_return(a_tag_list)

    @client.should_receive(:make_api_request) \
                   .with("tag", {}, {}) \
                   .and_return(an_api_response)


    tags = @tag_manager.get_tag_list
    tags.should == a_tag_list
  end


end
