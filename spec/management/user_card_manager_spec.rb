require File.expand_path('../../spec_helper', __FILE__)

describe "UserCardManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @card_manager = Sevendigital::UserCardManager.new(@client)
  end

  it "get should call user/payment/card api method and return list of cards" do
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    a_card_list = [Sevendigital::Card.new(@client)]
    an_api_response = fake_api_response("user/payment/card/index")
    options = {:pagesize => 20 }

    mock_client_digestor(@client, :user_card_digestor) \
          .should_receive(:list_from_xml).with(an_api_response.content.cards).and_return(a_card_list)

    @client.should_receive(:make_signed_api_request) \
              .with(:GET, "user/payment/card", {}, options, a_token) \
              .and_return(an_api_response)

    cards = @card_manager.get_card_list(a_token, options)
    cards.should == a_card_list
  end

end