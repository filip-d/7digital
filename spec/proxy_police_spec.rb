# encoding: UTF-8
require 'date'
require "spec_helper"

describe "Proxy Police" do

  it "should create a Peachy proxy from xml string with root element with given name" do

    xml = <<XML
    <rootElement id="123">
      <subElement>expected value</subElement>
    </rootElement>
XML

    proxy = Sevendigital::ProxyPolice.create_release_proxy(xml, :root_element)
    proxy.kind_of?(Peachy::Proxy).should == true
    proxy.sub_element.value.should == "expected value"
  end

  it "should create a Peachy proxy from root of the xml string if no element name given" do

   xml = <<XML
    <rootElement id="123">
      <subElement>expected value</subElement>
    </rootElement>
XML

    proxy = Sevendigital::ProxyPolice.create_release_proxy(xml, nil)
    proxy.kind_of?(Peachy::Proxy).should == true
    proxy.root_element.sub_element.value.should == "expected value"

  end

  it "should not create a Peachy proxy from xml string without root element with given name" do

    xml = <<XML
    <rootElement id="123">
      <subElement>expected value</subElement>
    </rootElement>
XML

    proxy = Sevendigital::ProxyPolice.create_release_proxy(xml, :different_element)
    proxy.should == nil

  end

    it "should just return the input if passed in Peachy proxy " do

    xml = <<XML
    <rootElement id="123">
      <subElement>expected value</subElement>
    </rootElement>
XML
    proxy = Peachy::Proxy.new(xml)
    checked_proxy = Sevendigital::ProxyPolice.ensure_is_proxy(proxy, nil)
    checked_proxy.should == proxy

    end

  it "should just return the input if passed in Peachy SimpleContent " do

    xml = "<element/>"
    proxy = Peachy::SimpleContent.new(xml)
    checked_proxy = Sevendigital::ProxyPolice.ensure_is_proxy(proxy, nil)
    checked_proxy.should == proxy

  end


end