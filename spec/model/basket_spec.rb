require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "Basket" do

  before do
    @client = stub(Sevendigital::Client)
    @basket_manager = mock(Sevendigital::BasketManager)
    @client.stub!(:basket).and_return @basket_manager
    
    @basket = Sevendigital::Basket.new(@client)
    @basket.id = "00000000-0000-0000-0000-000000000001"
  end

  it "add_item should should call add_item on basket manager and update the basket items" do
    expected_options = {:page => 2}
    a_track_id = 123
    a_release_id = 456

    a_basket_id = @basket.id
    an_updated_basket = fake_basket_with_items(@basket.id)

    @basket_manager.should_receive(:add_item) { |basket_id, release_id, track_id, options|
      basket_id.should == @basket.id
      release_id.should == a_release_id
      track_id.should == a_track_id
      (options.keys & expected_options.keys).should == expected_options.keys
      an_updated_basket
    }
    @basket.add_item(a_release_id, a_track_id, expected_options)
    
    @basket.id.should == a_basket_id
    @basket.basket_items.should == an_updated_basket.basket_items
   
  end

  it "remove_item should should call remove_item on basket manager and update the basket items" do
    expected_options = {:page => 2}
    an_item_id = 123

    a_basket_id = @basket.id
    an_updated_basket = fake_basket_with_items(@basket.id)

    @basket_manager.should_receive(:remove_item) { |basket_id, item_id, options|
      basket_id.should == @basket.id
      item_id.should == an_item_id
      (options.keys & expected_options.keys).should == expected_options.keys
      an_updated_basket
    }
    @basket.remove_item(an_item_id, expected_options)

    @basket.id.should == a_basket_id
    @basket.basket_items.should == an_updated_basket.basket_items

  end


  def fake_basket_with_items(id)
    basket = Sevendigital::Basket.new(@client)
    basket.id = id
    basket.basket_items = [Sevendigital::BasketItem.new(@client), Sevendigital::BasketItem.new(@client)]
    basket
end
end