class FastSearchesController < ApplicationController
  layout "blank"

  before_filter :view_layout

  respond_to :html, :json

  def new
    @fast_search = FastSearch.new
    search
  end

  def show
    @fast_search = FastSearch.find_by(uid: params[:id])
    search
  end

  def create
    @fast_search = FastSearch.new(search_params)
    @fast_search.save

    respond_with @fast_search
  end

  def update
    @fast_search = FastSearch.find_by(uid: params[:id])
    @fast_search.update_attributes search_params
    respond_with @fast_search
  end

  def search_params
    params.require(:fast_search).permit(:query)
  end

  def search
    @item_search = Elastic::ItemSearch.new(@fast_search, params)
    @tire_search = @item_search.fast_search
    @results = ItemDecorator.decorate_collection(
      @tire_search.results,
      context: { size: layout_size }
    )
  end
end
