# coding: utf-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

describe "ListItemDigestor" do

  before do
    @list_item_digestor = Sevendigital::ListItemDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <foo id="123">
      <bar>test</bar>
    </foo>
XML

    running {@list_item_digestor.from_xml_doc(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should digest list item xml and populate available properties" do

    xml_response = load_sample_object_xml("list_item_release")

    list_item = @list_item_digestor.from_xml_string(xml_response)

    list_item.id.should == 123456
    list_item.type.should == :release
    list_item.release.id.should == 1136112
    list_item.release.title.should == "Collapse Into Now"
    list_item.release.artist.id.should == 590
    list_item.release.artist.name.should == "R.E.M."
    list_item.release.artist.appears_as == "R.E.M."
    list_item.release.artist.url.should == "http://www.7digital.com/artists/r-e-m"
    list_item.release.url.should == "http://www.7digital.com/artists/r-e-m/collapse-into-now?partner=123"
    list_item.release.image.should == "http://cdn.7static.com/static/img/sleeveart/00/011/361/0001136112_50.jpg"
    list_item.release.explicit_content == false
  end

   it "should not digest unknown list item xml but throw up (exception) " do

    xml_response = <<XML
    <listItem id="123">
      <type>track</type>
      <track id="1136112">
      </track>
    </release>
XML

     running {@list_item_digestor.from_xml_doc(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should digest xml containing list of list items and return an  array" do

    xml_response = load_sample_object_xml("list_item_list")

    list_items = @list_item_digestor.list_from_xml_string(xml_response)
    list_items[0].id.should == 1879539
    list_items[0].release.id.should == 1879539
    list_items[1].id.should == 1879543
    list_items[1].release.id.should == 1879543
    list_items.size.should == 2

  end

  it "should digest xml containing empty list of list items and return an empty array" do

    xml_response = <<XML
    <listItems>
    </listItems>
XML

    releases = @list_item_digestor.list_from_xml_string(xml_response)
    releases.size.should == 0

  end


end
