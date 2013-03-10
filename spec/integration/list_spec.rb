# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)

describe "List integration tests" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

  it "should get editorial list" do
    list = @api_client.list.get_editorial_list("new_releases")
    list.key.should == "new_releases"
    list.id.should > 0
    list.list_items.size.should > 1
    list.list_items[0].release.type.should == :album
  end

end
