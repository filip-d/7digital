module Sevendigital

  #@private
  class LockerTrackDigestor < Digestor # :nodoc:
    
    def default_element_name; :locker_track end
    def default_list_element_name; :locker_tracks end

    def from_proxy(locker_track_proxy)
      make_sure_not_eating_nil(locker_track_proxy)
      locker_track = Sevendigital::LockerTrack.new(@api_client)
      locker_track.track = @api_client.track_digestor.from_xml(locker_track_proxy.track)
      locker_track.remaining_downloads = locker_track_proxy.remaining_downloads.value.to_i
      locker_track.purchase_date =  DateTime.parse(locker_track_proxy.purchase_date.value.to_s)
      locker_track.download_urls = @api_client.download_url_digestor.list_from_xml(locker_track_proxy.download_urls)

      return locker_track
    end

  end

end
