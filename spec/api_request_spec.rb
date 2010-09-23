require File.join(File.dirname(__FILE__), %w[spec_helper])

describe "ApiRequest" do

  it "should merge method parameters and options with parameters taking preference" do

    parameters = {:trackId => 123, :releaseId => 456, :country => "CU"}
    options = {:page => 1, :country => "US",  :trackId => "SS"}
    request = Sevendigital::ApiRequest.new('method', parameters, options)
    request.parameters[:trackId].should == 123
    request.parameters[:releaseId].should == 456
    request.parameters[:country].should == "CU"
    request.parameters[:page].should == 1
    request.parameters.keys.size.should == 4 # page_size == null

  end

  it "should provide paging parameters in 7digital API format" do

    request = Sevendigital::ApiRequest.new('method', {}, {:page => 5, :per_page => 3 })
    request.parameters[:page].should == 5
    request.parameters[:pageSize].should == 3

	end

end
