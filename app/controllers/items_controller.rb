class ItemsController < ApplicationController
  respond_to :html, :json

  before_filter :view_layout, only: [:show]
  before_filter :find_item
  before_filter :create_cart, only: [:add_to_cart, :remove_from_cart]

  def show
    context = { context: { size: layout_size } }
    @item = ItemDecorator.new(@item, context)
    @similar_item_search = Elastic::SimilarItemSearch.new(@item.model, params)
    @similar_items = ItemDecorator.decorate_collection(
      @similar_item_search.tire_search.results,
      context
    )
  end

  def verify
    return render(status: 500) unless @item

    verifier = ItemVerifier.new(@item)
    success = verifier.verify_item

    if success
      respond_with @item, layout: false
    else
      render status: 500
    end
  end

  def add_to_cart
    @cart.add_item(@item)
    @cart.save
    respond_to do |format|
      format.html { redirect_to item_url(@item) }
      format.json
    end
  end

  def remove_from_cart
    @cart.remove_item(@item)
    @cart.save
    respond_to do |format|
      format.html { redirect_to item_url(@item) }
      format.json
    end
  end

  def destroy
    @item.destroy
    authorize! :destroy, @item
    respond_with @item, location: root_url
  end

  private

  def find_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    if request.xhr?
      render(status: 500)
    else
      redirect_to(
        root_url,
        notice: "This item doesn't exist. It was probably removed when it became unverified."
      )
    end
  end

  def create_cart
    authorize! :create, UserFavorite
    @user = current_user
    @cart = ShoppingCart.new(@user)
  end
end
