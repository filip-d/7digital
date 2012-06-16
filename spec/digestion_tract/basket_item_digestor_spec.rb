# coding: utf-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

describe "BasketItemDigestor" do

  before do
    @basket_item_digestor = Sevendigital::BasketItemDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <artist id="123">
      <name>expected artist name</name>
    </artist>
XML

    running {@basket_item_digestor.from_xml_string(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should digest basket item xml and populate all properties" do

    xml_response = load_sample_object_xml("basket_item")

    basket_item = @basket_item_digestor.from_xml_string(xml_response)
    basket_item.id.should == 15284882
    basket_item.type.should == :track
    basket_item.item_name.should == "Test"
    basket_item.artist_name.should == "Ghetto"
    basket_item.track_id.should == 2458384
    basket_item.release_id.should == 224820
    basket_item.price.value.should == 0.99
  end

  it "should digest xml containing list of basket items and return an array" do

    xml_response = load_sample_object_xml("basket_item_list")

    basket_items = @basket_item_digestor.list_from_xml_string(xml_response)
    basket_items[0].id.should == 15284882
    basket_items[0].type.should == :track
    basket_items[1].id.should == 15284883
    basket_items[1].type.should == :release
    basket_items.size.should == 2

  end

  it "should digest xml containing empty list of releases and return an empty paginated array" do

    xml_response = load_sample_object_xml("basket_item_list_empty")

    basket_items = @basket_item_digestor.list_from_xml_string(xml_response)
    basket_items.size.should == 0

  end

end
