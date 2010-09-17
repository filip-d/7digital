require "spec"
require "sevendigital"

describe "PriceDigestor" do

  before do
     @price_digestor = Sevendigital::PriceDigestor.new(nil)
  end

   it "should not digest from invalid xml but throw up (exception)" do

     xml_response = <<XML
     <xxx>
       <currency code="XXX">X</currency>
     </xxx>
XML

    running {@price_digestor.from_xml(xml_response)}.should raise_error Sevendigital::DigestiveProblem
  end

  it "should parse from xml and populate minimum available properties" do

    xml_response = <<XML 
<price>
  <currency code="GBP">£</currency>
  <value>1.79</value>
  <formattedPrice>£1.79</formattedPrice>
  <onSale>true</onSale>
</price>
XML

    price = @price_digestor.from_xml(xml_response)
    price.currency_code.should == :GBP
    price.currency_symbol.should == "£"
    price.value.should == 1.79
    price.formatted_price.should == "£1.79"
    price.rrp.should == nil
    price.formatted_rrp.should == nil
    price.on_sale.should == true

  end

  it "should parse from xml and populate all properties" do

    xml_response = load_sample_object_xml("price")

    price = @price_digestor.from_xml(xml_response)
    price.currency_code.should == :GBP
    price.currency_symbol.should == "£"
    price.value.should == 1.79
    price.formatted_price.should == "£1.79"
    price.rrp.should == 1.99
    price.formatted_rrp.should == "£1.99"
    price.on_sale.should == true
  end

end
