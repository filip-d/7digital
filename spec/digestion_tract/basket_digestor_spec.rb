require File.expand_path('../../spec_helper', __FILE__)

describe "BasketDigestor" do

  before do
     @basket_digestor = Sevendigital::BasketDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
<zzz id="17">
	<fileFormat>MP3</fileFormat>
	<bitRate>320</bitRate>
	<drmFree>True</drmFree>
</zzz>
XML

    running {@basket_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from Basket xml and populate all properties" do

    xml_response = load_sample_object_xml("basket")

    basket = @basket_digestor.from_xml(xml_response)
    basket.id.should == "00000000-0000-0000-0000-000000000000"
    basket.basket_items.size == 1
    basket.basket_items[0].id == 15284882
  end

end