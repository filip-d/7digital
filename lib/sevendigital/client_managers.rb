module Sevendigital

  class Client

    #@return [ArtistManager]
    def artist
      @artist_manager ||= ArtistManager.new(self)
    end

    #@return [BasketManager]
    def basket
      @basket_manager ||= BasketManager.new(self)
    end

    #@return [CountrytManager]
    def country
      @country_manager ||= CountryManager.new(self)
    end

    #@return [ListManager]
    def list
      @list_manager ||= ListManager.new(self)
    end

    #@return [ReleaseManager]
    def release
      @release_manager ||= ReleaseManager.new(self)
    end

    #@return [TagManager]
    def tag
      @tag_manager ||= TagManager.new(self)
    end
    
    #@return [TrackManager]
    def track
      @track_manager ||= TrackManager.new(self)
    end

    #@return [UserManager]
    def user
      @user_manager ||= UserManager.new(self)
    end

    #@return [UserManager]
    def user_payment_card
      @user_card_manager ||= UserCardManager.new(self)
    end

    #@return [OAuthManager]
    def oauth
      @oauth_manager ||= OAuthManager.new(self)
    end

  end

end
