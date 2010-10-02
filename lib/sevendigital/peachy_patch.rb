module Peachy
  module MorphIntoArray
    private

    def array_can? method_name
      (Array.instance_methods - Object.instance_methods).include?( version_safe_method_id(method_name))
    end
  end
end

if RUBY_VERSION < "1.9"
  def version_safe_method_id(method_name)
    method_name.to_s
  end
else
  def version_safe_method_id(method_name)
    method_name.to_sym
  end
end
