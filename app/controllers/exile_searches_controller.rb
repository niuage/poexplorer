class ExileSearchesController < ApplicationController
  layout 'exiles'

  respond_to :html

  before_filter :find_search, only: [:show, :edit, :update]

  def index
    search
    render :new
  end

  def show
    search
  end

  def create
    @search = ExileSearch.new(params[:exile_search])
    @search.user = current_user if user_signed_in?

    @search.save

    search if !@search.valid?

    respond_with @search, location: location
  end

  def update
    @search.update_attributes(params[:exile_search])
    search if !@search.valid?

    respond_with @search, location: location
  end

  private

  def build_search
    return if @search
    @search = ::ExileSearch.new(search_params)
  end

  def search
    build_search
    # update_from_url_params(@search)

    @searchable = Elastic::ExileSearch.new(@search, params)
    @tire_search = @searchable.tire_search
    @results = ExileDecorator.decorate_collection(@tire_search.results)
  end

  def search_params
    params[:search] # ??????????
  end

  def location
    @search.errors.any? ? nil : @search
  end

  def find_search
    @search = ::ExileSearch.find_by(uid: params[:id])
    return redirect_to(root_url, notice: "This search could not be found, sorry.") unless @search
  end
end
