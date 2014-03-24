module UserShops
  class ShopsController < ::ApplicationController
    include Concerns::Search

    respond_to :html

    before_filter :find_user
    before_filter :find_shop, only: [:show]
    before_filter :authorize_read, only: [:show]
    before_filter :view_layout, only: [:show]

    def index
      shops = @user.shops.includes(:user, :league).page(params[:page])
      shops = shops.visible if !user_signed_in? || !current_user.is?(@user)
      @shops = ShopDecorator.decorate_collection(shops)
      respond_with @shops
    end

    def show
      @search = Search.new
      @search.build_item do |item|
        item.shop_id = @shop.id
      end
      update_from_url_params(@search)
      @results = ItemDecorator.decorate_collection(
        Elastic::ItemSearch.new(@search, params)
          .tire_search
          .results,
        context: { size: layout_size }
      )

      @price_setter = can? :update, @shop
      @user = @shop.user
      respond_with @shop
    end

    private

    def find_user
      @user = User.find(params[:user_id])
    end

    def find_shop
      @shop = @user.shops.find(params[:id])
      @shop = @shop.decorate
    end

    def authorize_read
      authorize! :read, @shop, message: "This shop is not public yet! Come back later."
    end

  end
end
