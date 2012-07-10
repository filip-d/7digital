require "date"
require File.expand_path('../../spec_helper', __FILE__)

describe "User" do

  before do
    @client = stub(Sevendigital::Client)
    @user_manager = mock(Sevendigital::UserManager)
    @user_card_manager = mock(Sevendigital::UserCardManager)
    @client.stub!(:user).and_return @user_manager
    @client.stub!(:user_payment_card).and_return @user_card_manager

    @user = Sevendigital::User.new(@client)
  end

  it "get_details should get user's basic details from manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    fresh_user = fake_user_with_details
    expected_options = {:page => 2}

    @user_manager.should_receive(:get_details) { |token, options|
      token.should == @user.oauth_access_token
      (options.keys & expected_options.keys).should == expected_options.keys
      fresh_user
    }
    @user.get_details(expected_options).should == fresh_user
    @user.email_address.should == fresh_user.email_address

  end

  it "should not be authorised if does not have access_token" do
    @user.oauth_access_token = nil
    @user.authenticated?.should == false
  end

  it "should be authorised if does have access_token" do
    @user.oauth_access_token = "something"
    @user.authenticated?.should == true
  end

  it "should get user's locker from locker manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    fake_locker = [Sevendigital::LockerRelease.new(@client)]
    expected_options = {:page => 2}

    @user_manager.should_receive(:get_locker) { |token, options|
      token.should == @user.oauth_access_token
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_locker
    }
    locker = @user.get_locker(expected_options)
    locker.should == fake_locker
  end

  it "should get user's payment cards from user card manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    fake_card_list = [Sevendigital::Card.new(@client)]
    expected_options = {:page => 2}

    @user_card_manager.should_receive(:get_card_list) { |token, options|
      token.should == @user.oauth_access_token
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_card_list
    }
    cards = @user.get_cards(expected_options)
    cards.should == fake_card_list
  end

  it "should add payment card for user using user card manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    card_number = "4444333322221111"
    card_type = "VISA"
    card_holder_name = "Mr John Simth"
    card_start_date = "200909"
    card_expiry_date = "201109"
    card_issue_number = "1"
    card_verification_code ="123"
    card_post_code = "EC2A 4HJ"
    card_country = "GB"
    fake_card = Sevendigital::Card.new(@client)

    @user_card_manager.should_receive(:add_card).with(
            card_number, card_type, card_holder_name, card_start_date, card_expiry_date, card_issue_number,
            card_verification_code, card_post_code, card_country, @user.oauth_access_token, {}).and_return(fake_card)
    card = @user.add_card(card_number, card_type, card_holder_name, card_start_date, card_expiry_date,
                          card_issue_number, card_verification_code, card_post_code, card_country)
    card.should == fake_card
  end

  it "should select a default payment card for user using user card manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    card_id = 123456

    @user_card_manager.should_receive(:select_card).with(
            card_id, @user.oauth_access_token, {}).and_return(true)
    @user.select_card(card_id).should == true
  end


  it "should purchase a track using user manger" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    a_release_id = 123
    a_track_id = 456
    a_price = 1.29
    fake_locker = [Sevendigital::LockerRelease.new(@client)]
    expected_options = {:page => 2}

    @user_manager.should_receive(:purchase_item) { |release_id, track_id, price, token, options|
      token.should == @user.oauth_access_token
      release_id.should == a_release_id
      track_id.should == a_track_id
      price.should == a_price
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_locker
    }
    purchase_locker = @user.purchase_item!(a_release_id, a_track_id, a_price, expected_options)
    purchase_locker.should == fake_locker
  end

  it "should purchase a basket using user manger" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    a_basket_id = 123
    fake_locker = [Sevendigital::LockerRelease.new(@client)]
    expected_options = {:page => 2}

    @user_manager.should_receive(:purchase_basket) { |basket_id, token, options|
      token.should == @user.oauth_access_token
      basket_id.should == a_basket_id
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_locker
    }
    purchase_locker = @user.purchase_basket!(a_basket_id, expected_options)
    purchase_locker.should == fake_locker
  end

  it "should get stream track url from user manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    a_track_id = 456
    a_release_id = 123
    a_stream_track_url = "http://whatever"
    expected_options = {:page => 2}

    @user_manager.should_receive(:get_stream_track_url) { |release_id, track_id, token, options|
      token.should == @user.oauth_access_token
      track_id.should == a_track_id
      release_id.should == a_release_id
      (options.keys & expected_options.keys).should == expected_options.keys
      a_stream_track_url
    }
    @user.stream_track_url(a_release_id, a_track_id, expected_options).should == a_stream_track_url
  end

  it "should not get a stream tack url but raise Sevendigital::Error if user is not authenticated" do
    running {@user.get_locker}.should raise_error(Sevendigital::SevendigitalError)
  end

  it "should get an add card url from user manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    a_stream_track_url = "http://whatever"
    a_return_url = "http://example.com"
    expected_options = {:page => 2}

    @user_manager.should_receive(:get_add_card_url) { |return_url, token, options|
      return_url.should == a_return_url
      token.should == @user.oauth_access_token
      (options.keys & expected_options.keys).should == expected_options.keys
      a_stream_track_url
    }
    @user.add_card_url(a_return_url, expected_options).should == a_stream_track_url
  end

  it "should not get a stream tack url but raise Sevendigital::Error if user is not authenticated" do
    running {@user.get_locker}.should raise_error(Sevendigital::SevendigitalError)
  end

  def fake_user_with_details
    user = Sevendigital::User.new(@client)
    user.email_address = "user@7digital.com"
    user
  end

end