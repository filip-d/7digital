module Sevendigital

  class Client

    def artist_digestor
      @artist_digestor ||= ArtistDigestor.new(self)
    end

    def basket_digestor
      @basket_digestor ||= BasketDigestor.new(self)
    end

    def basket_item_digestor
      @basket_item_digestor ||= BasketItemDigestor.new(self)
    end

    def download_url_digestor
      @download_url_digestor ||= DownloadUrlDigestor.new(self)
    end

    def format_digestor
      @format_digestor ||= FormatDigestor.new(self)
    end

    def label_digestor
      @label_digestor ||= LabelDigestor.new(self)
    end

    def locker_digestor
      @locker_digestor ||= LockerDigestor.new(self)
    end

    def locker_release_digestor
      @locker_release_digestor ||= LockerReleaseDigestor.new(self)
    end

    def locker_track_digestor
      @locker_track_digestor ||= LockerTrackDigestor.new(self)
    end

    def price_digestor
      @price_digestor ||= PriceDigestor.new(self)
    end

    def pager_digestor
      @pager_digestor ||= PagerDigestor.new(self)
    end

    def release_digestor
      @release_digestor ||= ReleaseDigestor.new(self)
    end

    def track_digestor
      @track_digestor ||= TrackDigestor.new(self)
    end

    def oauth_request_token_digestor
      @oauth_request_token_digestor ||= OAuthRequestTokenDigestor.new(self)
    end

    def oauth_access_token_digestor
      @oauth_access_token_digestor ||= OAuthAccessTokenDigestor.new(self)
    end

    def api_response_digestor
      @api_response_digestor ||= ApiResponseDigestor.new(self)
    end
    
    def chart_item_digestor
      @chart_item_digestor ||= ChartItemDigestor.new(self)
    end
    
  end

end
