require "spec_helper"

describe "ApiRequest" do

  it "should always provide selected parameters in 7digital API format" do

    request = Sevendigital::ApiRequest.new('method', {
            :page => 5,
            :per_page => 3,
            :shop_id => 99,
            :image_size => 999
    })
    request.comb_parameters
    request.parameters[:page].should == 5
    request.parameters[:pageSize].should == 3
    request.parameters[:per_page].should == nil
    request.parameters[:shopId].should == 99
    request.parameters[:shop_id].should == nil
    request.parameters[:imageSize].should == 999
    request.parameters[:image_size].should == nil

  end

  it "should not contain nil parameters" do

    request = Sevendigital::ApiRequest.new('method', {:key1 => "value", :key2 => nil})
    request.comb_parameters
    request.parameters[:key1].should == "value"
    request.parameters.has_key?(:key2).should == false

  end

end
