class ClassAttributeHandler < YARD::Handlers::Ruby::AttributeHandler
  handles method_call(:sevendigital_basic_property)
  handles method_call(:sevendigital_extended_property)

  def process
     super
  end
end
