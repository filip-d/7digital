module Peachy
  class Proxy
    def ==(other_proxy)
      (to_s == other_proxy.to_s)
    end
  end
end