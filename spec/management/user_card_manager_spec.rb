require File.expand_path('../../spec_helper', __FILE__)

describe "UserCardManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @card_manager = Sevendigital::UserCardManager.new(@client)
  end

  it "get should call user/payment/card api method and return list of cards" do
    a_card_list = [Sevendigital::Card.new(@client)]
    an_api_response = fake_api_response("user/payment/card")
    options = {:pagesize => 20 }

    mock_client_digestor(@client, :user_card_digestor) \
          .should_receive(:list_from_xml).with(an_api_response.content.cards).and_return(a_card_list)

    @client.should_receive(:make_api_request) \
              .with(:GET, "user/payment/card", {}, options) \
              .and_return(an_api_response)

    cards = @card_manager.get()
    cards.should == a_card_list
  end

  it "create should call basket/create api method and return digested created basket" do
    a_basket = Sevendigital::Basket.new(@client)
    an_api_response = fake_api_response("basket/create")
    options = {:pagesize => 20 }

    mock_client_digestor(@client, :basket_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.basket).and_return(a_basket)

    @client.should_receive(:make_api_request) \
              .with(:GET, "basket/create", {}, {}) \
              .and_return(an_api_response)

    basket = @card_manager.create
    basket.should == a_basket
  end

  it "add_item should call basket/addItem api method and return digested basket" do
    a_basket_id = "00000000-0000-0000-0000-000000000001"
    a_release_id = 123
    a_track_id = 456
    a_basket = Sevendigital::Basket.new(@client)
    an_api_response = fake_api_response("basket/additem")

    mock_client_digestor(@client, :basket_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.basket).and_return(a_basket)

    @client.should_receive(:make_api_request) \
      .with(:GET, "basket/addItem", {:basketId => a_basket_id, :releaseId => a_release_id, :trackId => a_track_id}, {}) \
      .and_return(an_api_response)

    basket = @card_manager.add_item(a_basket_id, a_release_id, a_track_id)
    basket.should == a_basket
  end

  it "remove_item should call basket/removeItem api method and return digested basket" do
    a_basket_id = "00000000-0000-0000-0000-000000000001"
    an_item_id = 123456
    a_basket = Sevendigital::Basket.new(@client)
    an_api_response = fake_api_response("basket/removeitem")

    mock_client_digestor(@client, :basket_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.basket).and_return(a_basket)

    @client.should_receive(:make_api_request) \
              .with(:GET, "basket/removeItem", {:basketId => a_basket_id, :itemId => an_item_id}, {}) \
              .and_return(an_api_response)

    basket = @card_manager.remove_item(a_basket_id, an_item_id)
    basket.should == a_basket
  end


end