# coding: utf-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

describe "ReleaseDigestor" do

  before do
    @release_digestor = Sevendigital::ReleaseDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <artist id="123">
      <name>expected artist name</name>
    </artist>
XML

    running {@release_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should digest release xml and populate minimum available properties" do

    xml_response = <<XML
    <release id="123">
      <title>expected release title</title>
      <artist id="345">
        <name>expected artist name</name>
        <appearsAs>expected displayed artist name</appearsAs>
      </artist>
    </release>
XML

    release = @release_digestor.from_xml(xml_response)
    release.id.should == 123
    release.title.should == "expected release title"
    release.artist.id.should == 345
    release.artist.name.should == "expected artist name"
    release.artist.appears_as == "expected displayed artist name"
  end

   it "should digest release xml and populate all available properties" do

    xml_response = load_sample_object_xml("release")

    release = @release_digestor.from_xml(xml_response)

    release.id.should == 155408
    release.title.should == "Dreams"
    release.version.should == "UK"
    release.type.should == :album
    release.barcode.should == "00602517512078"
    release.year.should == 2007
    release.explicit_content.should == false
    release.artist.id.should == 29755
    release.artist.name.should == "The Whitest Boy Alive"
    release.artist.appears_as.should == "The Whitest Boy Alive"
    release.release_date.should == DateTime.new(2007,10,22,0,0,0, 1.quo(24))
    release.added_date.should == DateTime.new(2007,10,11,11,18,29, 0)
    release.price.currency_code.should == :GBP
    release.price.currency_symbol.should == "£"
    release.price.value.should == 5
    release.price.formatted_price.should == "£5.00"
    release.price.rrp.should == 7.79
    release.price.formatted_rrp.should == "£7.79"
    release.price.on_sale.should == true
    release.formats.size.should == 2
    release.formats[0].id.should == 17
    release.formats[1].id.should == 1
    release.label.id.should == 40
    release.label.name.should == "Universal-Island Records Ltd."
    release.image.should == "http://cdn.7static.com/static/img/sleeveart/00/001/554/0000155408_50.jpg"
    release.url.should == "http://www.7digital.com/artists/the-whitest-boy-alive/dreams-(1)/?partner=123"
    release
  end

  it "should digest xml containing list of releases and return a paginated array" do

    xml_response = load_sample_object_xml("release_list")

    releases = @release_digestor.list_from_xml(xml_response, :results)
    releases[0].id.should == 123
    releases[0].artist.id.should == 345
    releases[1].id.should == 456
    releases[1].artist.id.should == 789
    releases.size.should == 2
    releases.total_entries.should == 50

  end

  it "should digest xml containing empty list of releases and return an empty paginated array" do

    xml_response = load_sample_object_xml("release_list_empty")

    releases = @release_digestor.list_from_xml(xml_response, :results)
    releases.size.should == 0
    releases.total_entries.should == 0

  end

end
