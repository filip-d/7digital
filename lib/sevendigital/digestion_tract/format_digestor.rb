module Sevendigital

  class FormatDigestor < Digestor

    def default_element_name; :format end
    def default_list_element_name; :formats end

    def from_proxy(format_proxy)
        make_sure_not_eating_nil (format_proxy)
        format = Format.new()
        format.id = format_proxy.id.to_i
        format.file_format = format_proxy.file_format.value.to_sym
        format.bit_rate = format_proxy.bit_rate.value.to_i
        format.drm_free = format_proxy.drm_free.value.to_s.downcase == "true"

        return format
    end

  end

end
