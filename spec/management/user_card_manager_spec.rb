require File.expand_path('../../spec_helper', __FILE__)

describe "UserCardManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @card_manager = Sevendigital::UserCardManager.new(@client)
  end

  it "get_card_list should call user/payment/card api method and return list of cards" do
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    a_card_list = [Sevendigital::Card.new(@client)]
    an_api_response = fake_api_response("user/payment/card/index")
    options = {:pagesize => 20 }

    mock_client_digestor(@client, :user_card_digestor) \
          .should_receive(:list_from_xml_doc).with(an_api_response.item_xml("cards")).and_return(a_card_list)

    @client.should_receive(:make_signed_api_request) \
              .with(:GET, "user/payment/card", {}, options, a_token) \
              .and_return(an_api_response)

    cards = @card_manager.get_card_list(a_token, options)
    cards.should == a_card_list
  end

  it "add_card should call user/payment/card/add api method and return the added card" do
    card_number = "4444333322221111"
    card_type = "VISA"
    card_holder_name = "Mr John Simth"
    card_start_date = "200909"
    card_expiry_date = "201109"
    card_issue_number = "1"
    card_verification_code ="123"
    card_post_code = "EC2A 4HJ"
    card_country = "GB"
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    a_card = Sevendigital::Card.new(@client)
    an_api_response = fake_api_response("user/payment/card/add")
    options = {:pagesize => 20 }

    mock_client_digestor(@client, :user_card_digestor) \
          .should_receive(:from_xml_doc).with(an_api_response.item_xml("card")).and_return(a_card)

    @client.should_receive(:make_signed_api_request) \
              .with(:POST, "user/payment/card/add", {
                  :cardNumber => card_number,
                  :cardType => card_type,
                  :cardHolderName => card_holder_name,
                  :cardStartDate => card_start_date,
                  :cardExpiryDate => card_expiry_date,
                  :cardIssueNumber => card_issue_number,
                  :cardVerificationCode => card_verification_code,
                  :cardPostCode => card_post_code,
                  :cardCountry => card_country
                }, options, a_token) \
              .and_return(an_api_response)

    card = @card_manager.add_card(
            card_number, card_type, card_holder_name, card_start_date, card_expiry_date, card_issue_number,
            card_verification_code, card_post_code, card_country, a_token, options)
    card.should == a_card
  end

  it "select_card should call user/payment/card/select api method and return true if successful " do
    card_id = 123
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    an_api_response = fake_api_response("user/payment/card/select")
    options = {:pagesize => 20 }

    @client.should_receive(:make_signed_api_request) \
              .with(:POST, "user/payment/card/select", {:cardId => card_id}, options, a_token) \
              .and_return(an_api_response)

    @card_manager.select_card(card_id, a_token, options).should == true
  end

end