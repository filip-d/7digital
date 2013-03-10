require "spec_helper"

describe "ApiRequest" do

  it "should always provide selected parameters in 7digital API format" do

    request = Sevendigital::ApiRequest.new(:METHOD, 'method', {
            :page => 5,
            :per_page => 3,
            :shop_id => 99,
            :image_size => 999
    })
    request.parameters[:page].should == 5
    request.parameters[:pageSize].should == 3
    request.parameters[:per_page].should == nil
    request.parameters[:shopId].should == 99
    request.parameters[:shop_id].should == nil
    request.parameters[:imageSize].should == 999
    request.parameters[:image_size].should == nil

  end

  it "should not contain nil parameters" do

    request = Sevendigital::ApiRequest.new(:METHOD, 'method', {:key1 => "value", :key2 => nil})
    request.parameters[:key1].should == "value"
    request.parameters.has_key?(:key2).should == false

  end

  it "parameters should not contain wrapper options" do

    request = Sevendigital::ApiRequest.new(:METHOD, 'method', {:key1 => "value", :cache_max_age => 123})
    request.parameters[:key1].should == "value"
    request.parameters.has_key?(:cache_max_age).should == false

  end

  it "options should be populated with wrapper options from parameters" do

    request = Sevendigital::ApiRequest.new(:METHOD, 'method', {:key1 => "value", :cache_max_age => 123})
    request.options[:cache_max_age].should == 123

  end

end
