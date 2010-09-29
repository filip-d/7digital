module Sevendigital

  class LockerReleaseDigestor < Digestor
    
    def default_element_name; :locker_release end
    def default_list_element_name; :locker_releases end

    def from_proxy(locker_release_proxy)
      make_sure_not_eating_nil(locker_release_proxy)
      locker_release = Sevendigital::LockerRelease.new(@api_client)
      locker_release.release = @api_client.release_digestor.from_xml(locker_release_proxy.release)
      locker_release.locker_tracks = @api_client.locker_track_digestor.list_from_xml(locker_release_proxy.locker_tracks, :locker_tracks)

      return locker_release
    end

  end

end
