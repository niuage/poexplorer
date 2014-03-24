class ShoppingCartsController < ApplicationController
  include Concerns::Search

  respond_to :html

  before_filter :authorize_cart
  before_filter :view_layout

  def show
    @search = Search.new
    update_from_url_params(@search)
    @searchable = Elastic::CartSearch.new(@search, params)
    @tire_search = @searchable.tire_search(current_user.cached_favorite_item_ids)
    @results = ItemDecorator.decorate_collection(@tire_search.results)
  end

  private

  def authorize_cart
    raise CanCan::AccessDenied.new("An error occured.", :manage, :all) unless user_signed_in?
  end

end
