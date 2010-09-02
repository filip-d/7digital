module Peachy
  class Proxy

  #  hide_public_methods ['kind_of?', 'send']

    def no_matching_xml method_name
      return nil
    end

    def ==(other_proxy)
      (to_s == other_proxy.to_s)
    end
  end
end
