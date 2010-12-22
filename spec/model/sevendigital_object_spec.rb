require "date"
require File.expand_path('../../spec_helper', __FILE__)

describe "SevendigitalObject" do

  before do

    @configuration = stub(OpenStruct)
    @configuration.stub!(:lazy_load?).and_return(true)

    @client = stub(Sevendigital::Client)
    @client.stub!(:configuration).and_return(@configuration)
    @client.stub!(:verbose?).and_return(true)
    @test_object = Sevendigital::SevendigitalObject.new(@client)
  end

  it "sevendigital extended property should define accessor that calls demand method" do
    class TestClass < Sevendigital::SevendigitalObject
      sevendigital_extended_property :test_property
    end

    test_object = TestClass.new(@client)
    test_object.should_receive(:demand_test_property)
    test_object.test_property

  end

  it "sevendigital extended property should define accessor that doesn't swallow SevenDigital errors" do
    class TestClass < Sevendigital::SevendigitalObject
      sevendigital_extended_property :test_property
    end
    @configuration.stub!(:ignorant_lazy_load?).and_return(false)
    test_object = TestClass.new(@client)
    test_object.should_receive(:demand_test_property).and_raise(Sevendigital::SevendigitalError)
    running {test_object.test_property}.should raise_error(Sevendigital::SevendigitalError)
  end
  
  it "sevendigital extended property should define accessor that swallows SevenDigital errors if client is ignorant" do
    class TestClass < Sevendigital::SevendigitalObject
      sevendigital_extended_property :test_property
    end
    @configuration.stub!(:ignorant_lazy_load?).and_return(true)
    test_object = TestClass.new(@client)
    test_object.should_receive(:demand_test_property).and_raise(Sevendigital::SevendigitalError)
    test_object.test_property
  end

  it "sevendigital extended property should define demand method that calls get method if property not set" do
    class TestClass < Sevendigital::SevendigitalObject
      sevendigital_extended_property :test_property
    end

    test_object = TestClass.new(@client)
    test_object.should_receive(:get_test_property).and_return("a value")
    test_object.instance_variable_get("@test_property").should == nil
    test_object.demand_test_property
    test_object.instance_variable_get("@test_property").should == "a value"

  end

  it "sevendigital extended property should define demand method that does nothing if property is set" do
    class TestClass < Sevendigital::SevendigitalObject
      sevendigital_extended_property :test_property
    end

    test_object = TestClass.new(@client)
    test_object.instance_variable_set("@test_property", "a value")
    test_object.should_not_receive(:get_test_property)
    test_object.demand_test_property

  end

  
end