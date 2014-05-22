class SearchesController < ApplicationController
  include Concerns::Search # I should create a SearchService instead (use virtus too)

  respond_to :html, :json

  before_filter :view_layout
  before_filter :find_search, only: [:show, :update, :destroy]
  before_filter :clean_up_stats, only: :update, if: ->(c) { request.xhr? }

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

  # if ajax request
  # used handle
  def clean_up_stats
    stats_array = search_params[:stats_attributes].to_a
    search_stats = @search.stats.pluck("id, mod_id")

    stats_array.select { |s| s[1][:_destroy] == "false" }.each do |stat|

      existing_stat_not_being_destroyed = begin
        new_stat?(stat) &&
        (search_stat = find_existing_stat_with_same_mod_id(search_stats, stat)) &&
        !(stat_being_destroyed?(stats_array, stat))
      end

      if existing_stat_not_being_destroyed
        stat[1][:id] = search_stat[0]
        search_params[:stats_attributes][stat[0]] = stat[1]
      end
    end
  end

  def new_stat?(stat)
    stat[1][:id].blank?
  end

  def find_existing_stat_with_same_mod_id(search_stats, stat)
    stat_mod_id = stat[1][:mod_id].to_i
    search_stats.find { |search_stat| search_stat[1] == stat_mod_id }
  end

  def stat_being_destroyed?(stats_array, stat)
    stat_mod_id = stat[1][:mod_id]
    stats_array.find { |s| s[1][:_destroy] == "1" && s[1][:mod_id] == stat_mod_id }
  end

end
