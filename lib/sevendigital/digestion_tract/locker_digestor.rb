module Sevendigital

  class LockerDigestor < Digestor

    def default_element_name; :locker end

    def from_proxy(locker_proxy)
        make_sure_not_eating_nil (locker_proxy)
        locker = Locker.new(@api_client)
        locker.locker_releases = @api_client.locker_release_digestor.list_from_proxy(locker_proxy.locker_releases)

        return locker
    end

  end

end
