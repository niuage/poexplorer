class SearchesController < ApplicationController
  include Concerns::Search # I should create a SearchService instead (use virtus too)

  respond_to :html, :json

  before_filter :view_layout
  before_filter :find_search, only: [:show, :update, :destroy]

  def index
    redirect_to new_polymorphic_search_path
  end

  def favorites
  end

  def show
    search
  end

  def new
    build_search
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
      stats: @search.stats.each_with_index.map { |stat, i|
        stat.attributes.slice(
          "id", "mod_id", "value", "max_value", "excluded", "required"
        ).merge({
          order: i,
          object_name: @search.model_name
        })
      },
      page: {
        path: @search.persisted? ? search_path : new_polymorphic_search_path,
        formPath: polymorphic_path(@search),
        title: @search.to_s,
        persisted: @search.persisted?,
        total: @results.total_pages,
        current: @results.current_page,
        results: {
          totalCount: @results.total_count
        }
      }
    }
  end

  def location
    (@search && @search.valid?) ? @search : nil
  end
end
