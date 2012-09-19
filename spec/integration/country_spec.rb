# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)

describe "Country integration tests" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

  it "should resolve country from IP address" do
    @api_client.country.resolve("1.2.3.4").should == 'AU'
  end

end
