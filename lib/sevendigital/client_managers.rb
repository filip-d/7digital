module Sevendigital

  class Client

    def artist
      @artist_manager ||= ArtistManager.new(self) 
    end

    def basket
      @basket_manager ||= BasketManager.new(self)
    end
    def release
      @release_manager ||= ReleaseManager.new(self)
    end

    def track
      @track_manager ||= TrackManager.new(self)
    end

    def user
      @user_manager ||= UserManager.new(self)
    end

    def oauth
      @oauth_manager ||= OAuthManager.new(self)
    end

  end

end
