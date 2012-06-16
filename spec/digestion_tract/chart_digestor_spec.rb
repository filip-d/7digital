require File.expand_path('../../spec_helper', __FILE__)

describe "ChartItemDigestor" do

  before do
    @chart_item_digestor = Sevendigital::ChartItemDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@chart_item_digestor.from_xml_string(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should digest artist chart item" do
    xml_response = load_sample_object_xml("artist_chart_item")

    chart_item = @chart_item_digestor.from_xml_string(xml_response)
    chart_item.position.should == 2
    chart_item.change.should == :up
    chart_item.item.id.should == 33154
    chart_item.item.class.should == Sevendigital::Artist
  end

  
  it "should digest release chart item" do
    xml_response = load_sample_object_xml("release_chart_item")

    chart_item = @chart_item_digestor.from_xml_string(xml_response)
    chart_item.position.should == 1
    chart_item.change.should == :up
    chart_item.item.id.should == 932151
    chart_item.item.class.should == Sevendigital::Release
    end

  it "should digest track chart item" do

    xml_response = load_sample_object_xml("track_chart_item")

    chart_item = @chart_item_digestor.from_xml_string(xml_response)
    chart_item.position.should == 99
    chart_item.change.should == :down
    chart_item.item.id.should == 2825304
    chart_item.item.class.should == Sevendigital::Track
  end


end