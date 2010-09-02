# encoding: UTF-8
require 'spec'
require 'date'
require File.join(File.dirname(__FILE__), %w[spec_helper])

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


end