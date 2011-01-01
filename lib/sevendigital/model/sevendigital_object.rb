class Class

  def sevendigital_basic_property(*properties)
    @basic_properties = []
    properties.each do |property|
      @basic_properties << "@#{property}".to_sym
      sevendigital_extended_property property, :get_details
    end
  end

  def sevendigital_extended_property(accessor, get_method = nil)

    get_method ||= "get_#{accessor.to_s}".to_sym
    demand_method = "demand_#{accessor.to_s}".to_sym

    define_method(demand_method) do |*options|
      if instance_variable_get("@#{accessor}").nil?  then
        value = send(get_method, *options)
        instance_variable_set("@#{accessor}", value) if get_method != :get_details
      end
    end

    define_method("#{accessor}") do |*options|
      begin
        send(demand_method, *options) if instance_variable_get("@#{accessor}").nil? && @api_client.configuration.lazy_load
      rescue Sevendigital::SevendigitalError => error
        puts "Error whilst lazyloading #{accessor} - #{error.error_code} #{error.error_message}" if @api_client.verbose?
        raise error if !@api_client.configuration.ignorant_lazy_load
      end
      instance_variable_get("@#{accessor}")
    end

     define_method("#{accessor}=") do |val|
       instance_variable_set("@#{accessor}",val)
     end
 end
end

module Sevendigital

  class SevendigitalObject

    def initialize(api_client)
      @api_client = api_client
    end

    def copy_basic_properties_from(other_object)
      self.class.instance_variable_get(:@basic_properties).each do |property|
         instance_variable_set(property, other_object.instance_variable_get(property))
      end
    end

  end

end

