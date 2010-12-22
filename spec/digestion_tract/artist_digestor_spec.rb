require File.expand_path('../../spec_helper', __FILE__)

describe "ArtistDigestor" do

  before do
    @artist_digestor = Sevendigital::ArtistDigestor.new(Sevendigital::Client.new(nil))
  end

 it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@artist_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)

  end

  it "should digest artist xml and populate minimum available properties" do

    xml_response = <<XML
    <artist id="123">
      <name>expected artist name</name>
    </artist>
XML

    artist = @artist_digestor.from_xml(xml_response)
    artist.id.should == 123
    artist.name.should == "expected artist name"
  end

   it "should digest artist xml and populate all available properties" do

    xml_response = load_sample_object_xml("artist")

    artist = @artist_digestor.from_xml(xml_response)
    artist.id.should == 123
    artist.name.should == "The Expected Artist"
    artist.sort_name.should == "Expected Artist, The"
    artist.appears_as.should == "The E.A."
    artist.image.should == "http://somewhere.com/tea.jpg"
    artist.url.should == "http://7digital.com/artists/tea?partner=1"
   end

    it "should digest xml containing list of artists and return a paginated array" do

    xml_response = load_sample_object_xml("artist_list")

    artists = @artist_digestor.list_from_xml(xml_response, :artists)
    artists[0].id.should == 14
    artists[1].id.should == 20
    artists[2].id.should == 106
    artists.size.should == 3
    artists.total_entries.should == 26

  end

  it "should digest xml containing empty list of releases and return an empty paginated array" do

    xml_response = load_sample_object_xml("artist_list_empty")

    artists = @artist_digestor.list_from_xml(xml_response, :artists)
    artists.size.should == 0
    artists.total_entries.should == 0

  end

   it "should not digest list from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@artist_digestor.list_from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)

  end

end