class ShopsController < ApplicationController
  respond_to :html

  before_filter :authorize_creation, only: [:create]
  before_filter :find_shop, only: [:show, :edit, :update, :destroy]
  before_filter :authorize_update, only: [:edit, :update, :destroy]

  def index
    shops = Shop.visible.includes(:user, :league).page(params[:page])

    @league_id = (params[:league].presence || user_league_id || League.first.id).to_i
    shops = shops.in_league(@league_id) if @league_id > 0

    shops = shops.sort_by(params[:sort])

    @shops = ShopDecorator.decorate_collection(shops)
    respond_with @shops
  end

  def show
    redirect_to [@shop.user, @shop]
  end

  def new
    @shop = Shop.new
  end

  def create
    return redirect_to shops_path, notice: "Shops are currently disabled."
    @shop = Shop.new(params[:shop]) do |shop|
      shop.user = current_user
      shop.processing = true
    end
    @shop.save
    if @shop.errors.any?
      location = nil
    else
      location =  [current_user, @shop]
      flash[:notice] = "Your shop was saved! It can take a few hours for PoExplorer to process it. Come back later."
    end
    respond_with @shop, location: location
  end

  def destroy
    @shop.destroy
    flash[:notice] = "Your shop was deleted successfully" if @shop.destroyed?
    respond_with @shop, location: [current_user, :shops]
  end

  private

  def authorize_creation
    authorize! :create, Shop
  end

  def authorize_update
    authorize! :update, @shop
  end

  def find_shop
    @shop = Shop.find(params[:id])
  end

  def with_league(shops)
    league = params[:league]
    shops.where(league_id: league.to_i) unless league.blank?
  end
end
