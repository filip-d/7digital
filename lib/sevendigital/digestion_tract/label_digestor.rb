module Sevendigital

  class LabelDigestor < Digestor

    def default_element_name; :label end
    def default_list_element_name; :labels end
    
    def from_proxy(label_proxy)
      puts "eating label"
      make_sure_not_eating_nil(label_proxy)

      label = Label.new()
      label.id = label_proxy.id.to_i
      label.name = label_proxy.name.value.to_s
      puts label_proxy.to_s

      return label
      end

  end

end