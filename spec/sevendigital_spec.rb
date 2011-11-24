# encoding: UTF-8
require "spec_helper"

describe "Sevendigital Gem" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

     it "should find an artist" do
       @api_client.artist.search("keane").first.name.should == "Keane"
     end

     it "should find at least 20 releases" do
       releases = @api_client.release.search("love", :page_size => 20, :page=>2)
       releases.size.should == 20
       releases.current_page.should == 2
       releases.total_entries.should > 100
       releases.first.price.value.should > 0
     end

     it "should find a track with price" do
       track = @api_client.track.search("radiohead creep").first
       track.artist.appears_as.should == "Radiohead"
       track.release.price.value.should > 1
       track.price.value.should > 0
     end

     it "should fail to sign up an existing user" do
       running {user = @api_client.user.sign_up("filip@7digital.com", "£$%^&*()_+")}.should raise_error(Sevendigital::SevendigitalError) { |error|
         error.error_message.should == "User with given email already exists"
         error.error_code.should == 2003
       }

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
