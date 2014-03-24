class Admin::ShopsController < Admin::AdminController
  respond_to :html

  def index
    @shops = ShopDecorator.decorate_collection(Shop.includes(:user, :league).page(params[:page]))
    respond_with @shops
  end
end
