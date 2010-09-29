module Sevendigital

  class LockerTrackDigestor < Digestor
    
    def default_element_name; :locker_track end
    def default_list_element_name; :locker_tracks end

    def from_proxy(locker_track_proxy)
      make_sure_not_eating_nil(locker_track_proxy)
      locker_track = Sevendigital::LockerRelease.new(@api_client)
#      locker_track.track = @api_client.release_digestor.from_xml(locker_track_proxy.release)
 #     locker_track.locker_tracks = @api_client.locker_track_digestor.list_from_xml(locker_track_proxy.locker_tracks, :locker_tracks)

      return locker_track
    end

  end

end
