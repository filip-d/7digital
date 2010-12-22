require File.expand_path('../../spec_helper', __FILE__)

describe "LabelDigestor" do

  before do
     @label_digestor = Sevendigital::LabelDigestor.new(nil)
  end


    it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@label_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
    end
  
  it "should digest label xml and populate all properties" do

    xml_response = <<XML
    <label id="123">
      <name>expected label name</name>
    </label>
XML

    label = @label_digestor.from_xml(xml_response)
    label.id.should == 123
    label.name.should == "expected label name"
  end

end