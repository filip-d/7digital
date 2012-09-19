require File.expand_path('../../spec_helper', __FILE__)

describe "ListManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @list_manager = Sevendigital::ListManager.new(@client)
  end

  it "get_editorial_list should call editorial/list api method and return digested list" do
    an_editorial_list_key = "featured"
    an_editorial_list = Sevendigital::List.new(@client)
    an_api_response = fake_api_response("editorial/list")

    mock_client_digestor(@client, :list_digestor) \
         .should_receive(:from_xml_doc).with(an_api_response.item_xml("list")).and_return(an_editorial_list)

    @client.should_receive(:make_api_request) \
            .with(:GET, "editorial/list", {:key => an_editorial_list_key}, {}) \
            .and_return(an_api_response)
    
    list = @list_manager.get_editorial_list(an_editorial_list_key)
    list.should == an_editorial_list
  end

end