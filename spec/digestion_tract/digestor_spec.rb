require File.expand_path('../../spec_helper', __FILE__)

describe "Digestor" do

  before do
    @digestor = Sevendigital::Digestor.new(Sevendigital::Client.new(nil))
  end

  it "should get nil if an optional element is missing" do

    xml = "<artist>test</artist>"
    result = @digestor.get_optional_value(Nokogiri::XML(xml), "release")
    result.should == nil

   end

 it "should get the value of optional element" do

   xml = "<release>test</release>"
   result = @digestor.get_optional_value(Nokogiri::XML(xml), "release")
   result.should == "test"

 end

  it "should get an optional value" do

    xml = "<release>123</release>"
    result = @digestor.get_optional_value(Nokogiri::XML(xml), "release") {|v| v.to_i}
    result.should == 123

  end


end