class SearchesController < ApplicationController
  include Concerns::Search # I should create a SearchService instead (use virtus too)

  respond_to :html, :json

  before_filter :view_layout
  before_filter :find_search, only: [:show, :update, :destroy]

  def index
    @searches = typed_search.includes(:item).page(params[:page]).per(10)
  end

  def favorites
  end

  def show
    search
  end

  def new
    search
  end

  def create
    @search = typed_search.new(search_params)
    @search.save unless first_request?
    search unless @search.valid?

    respond_with @search, location: location do |format|
      format.html
      format.json { ajax_search }
    end
  end

  def update
    @search.update_attributes(search_params)
    search unless @search.valid?

    respond_with @search, location: location do |format|
      format.html
      format.json { ajax_search }
    end
  end

  private

  def first_request?
    request.xhr? && params[:first]
  end

  def ajax_search
    search

    page = params[:page].to_i
    search_path = polymorphic_path(@search, page: page > 1 ? page : nil)

    render json: {
      results: @tire_search.results,
      facets: @results.facets,
      stats: @search.stats.map do |stat|
        { mod_id: stat.mod_id, id: stat.id }
      end,
      page: {
        path: @search.persisted? ? search_path : new_polymorphic_search_path,
        formPath: polymorphic_path(@search),
        current: @results.current_page,
        title: @search.to_s,
        persisted: @search.persisted?,
        results: {
          totalPages: @results.total_pages,
          totalCount: @results.total_count,
        }
      }
    }
  end

  def location
    (@search && @search.valid?) ? @search : nil
  end

end
