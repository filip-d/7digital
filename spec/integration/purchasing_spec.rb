# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)
require 'date'

describe "Purchasing integration tests" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

  it "should create and purchase basket" do
    test_track_id = 8515447
    basket = @api_client.basket.create
    basket.add_item(769006, test_track_id)

    user = @api_client.user.authenticate("test@7digital.com", "password")
    purchase_response = user.purchase_basket!(basket.id)
    purchase_response.locker_releases.first.locker_tracks.first.track.id.should == test_track_id
  end
end
