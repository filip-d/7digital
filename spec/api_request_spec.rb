require File.join(File.dirname(__FILE__), %w[spec_helper])

describe "ApiRequest" do

  it "should provide paging parameters in 7digital API format" do

    request = Sevendigital::ApiRequest.new('method', {:page => 5, :per_page => 3 })
    request.comb_parameters
    request.parameters[:page].should == 5
    request.parameters[:pageSize].should == 3

  end

  it "should provide shop ID parameter in 7digital API format" do

    request = Sevendigital::ApiRequest.new('method', {:shop_id => 123 })
    request.comb_parameters
    request.parameters[:shopId].should == 123
    request.parameters[:shop_id].should == nil

  end

  it "should not contain nil parameters" do

    request = Sevendigital::ApiRequest.new('method', {:key1 => "value", :key2 => nil})
    request.comb_parameters
    request.parameters[:key1].should == "value"
    request.parameters.has_key?(:key2).should == false

  end

end
