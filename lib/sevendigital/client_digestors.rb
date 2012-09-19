module Sevendigital

  class Client #:nodoc:

    #@private
    def api_response_digestor
      @api_response_digestor ||= ApiResponseDigestor.new(self)
    end

    #@private
    def artist_digestor
      @artist_digestor ||= ArtistDigestor.new(self)
    end

    #@private
    def basket_digestor
      @basket_digestor ||= BasketDigestor.new(self)
    end

    #@private
    def basket_item_digestor
      @basket_item_digestor ||= BasketItemDigestor.new(self)
    end

    #@private
    def chart_item_digestor
      @chart_item_digestor ||= ChartItemDigestor.new(self)
    end

    #@private
    def download_url_digestor
      @download_url_digestor ||= DownloadUrlDigestor.new(self)
    end

    #@private
    def format_digestor
      @format_digestor ||= FormatDigestor.new(self)
    end

    #@private
    def label_digestor
      @label_digestor ||= LabelDigestor.new(self)
    end

    #@private
    def locker_digestor
      @locker_digestor ||= LockerDigestor.new(self)
    end

    #@private
    def locker_release_digestor
      @locker_release_digestor ||= LockerReleaseDigestor.new(self)
    end

    #@private
    def locker_track_digestor
      @locker_track_digestor ||= LockerTrackDigestor.new(self)
    end

    #@private
    def list_digestor
      @list_digestor ||= ListDigestor.new(self)
    end

    #@private
    def list_item_digestor
      @list_item_digestor ||= ListItemDigestor.new(self)
    end

    #@private
    def oauth_request_token_digestor
      @oauth_request_token_digestor ||= OAuthRequestTokenDigestor.new(self)
    end

    #@private
    def oauth_access_token_digestor
      @oauth_access_token_digestor ||= OAuthAccessTokenDigestor.new(self)
    end

    #@private
    def pager_digestor
      @pager_digestor ||= PagerDigestor.new(self)
    end

    #@private
    def price_digestor
      @price_digestor ||= PriceDigestor.new(self)
    end

    #@private
    def release_digestor
      @release_digestor ||= ReleaseDigestor.new(self)
    end

    #@private
    def track_digestor
      @track_digestor ||= TrackDigestor.new(self)
    end

    #@private
    def tag_digestor
      @tag_digestor ||= TagDigestor.new(self)
    end

    #@private
    def user_card_digestor
      @user_card_digestor ||= UserCardDigestor.new(self)
    end

    #@private
    def user_digestor
      @user_digestor ||= UserDigestor.new(self)
    end

  end

end
