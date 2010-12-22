#$: << 'sevendigital'
#$: << 'spec'

require 'simplecov'

SimpleCov.start do
  add_group 'Management', 'lib/sevendigital/management'
  add_group 'Digestion', 'lib/sevendigital/digestion_tract'
  add_group 'Model', 'lib/sevendigital/model'
end

require 'spec'
require File.expand_path(
    File.join(File.dirname(__FILE__), %w[.. lib sevendigital]))

require "peachy_spec_helper_patch"

Peachy.whine

Spec::Runner.configure do |config|
  # == Mock Framework 
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

  alias running lambda

  def load_sample_method_xml(method_name)
    method_name = "test-xml/methods/" + method_name + ".xml"
    IO.read( File.join(File.dirname(__FILE__), method_name.split('/')))
  end

  def load_sample_object_xml(method_name)
    method_name = "test-xml/objects/" + method_name + ".xml"
    IO.read( File.join(File.dirname(__FILE__), method_name.split('/')))
  end

  def fake_api_response(method_name)
    Sevendigital::ApiResponseDigestor.new(nil).from_xml(load_sample_method_xml(method_name))
  end

  def fake_api_error_response(code)
    Sevendigital::ApiResponseDigestor.new(nil).from_xml("<response status=\"error\"><error code=\"#{code}\"></error></response>")
  end

  def mock_client_digestor(client, digestor_class)
    digestor = mock(Sevendigital.const_get(camelize(digestor_class.to_s)))
    client.stub!(digestor_class).and_return(digestor)
    digestor
  end

  def camelize(str)
    str.split('_').map {|w| w.capitalize}.join
  end

