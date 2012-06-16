# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)
require 'date'

describe "Release integration tests" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

  it "should get releases by date" do
    releases = @api_client.release.get_by_date(Date.today, Date.today)
    releases.each do |release|
      release.id.should >= 1
      release.title.should_not be_empty
      release.artist.should_not be_nil
      release.price.value.should >= 0
      release.release_date.to_date.should == Date.today
    end
  end

  it "should search and find releases" do
    releases = @api_client.release.search("love", :page_size => 20, :page=>2)
    releases.size.should == 20
    releases.current_page.should == 2
    releases.total_entries.should > 100
    releases.first.price.value.should > 0
  end

end
