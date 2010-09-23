require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "PagerDigestor" do

  before do
     @pager_digestor = Sevendigital::PagerDigestor.new(nil)
  end


    it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@pager_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
    end

 it "should not digest if paging info is missing from xml but spit out nil" do

    xml_response = <<XML
    <results id="123">
      <page>3</page>
      <totalItems>99</totalItems>
      <pageSizeElementMissing>22</pageSizeElementMissing>
    </results>
XML

    pager = @pager_digestor.from_xml(xml_response, :results)
    pager.should == nil
  end

  it "should digest from xml and populate all properties" do

    xml_response = <<XML
    <pager a="b">
      <page>3</page>
      <totalItems>99</totalItems>
      <pageSize>22</pageSize>
    </pager>
XML

    pager = @pager_digestor.from_xml(xml_response, :pager)
    pager.page.should == 3
    pager.page_size.should == 22
    pager.total_items.should == 99
  end
  
end