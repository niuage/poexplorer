class Admin::SearchesController < Admin::AdminController
  def index
    @searches_count = Search.count
    @user_count = User.count
    @auth_count = Authentication.count
    @user_favorites_count = UserFavorite.count
  end
end
