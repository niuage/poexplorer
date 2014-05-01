class ExileSearchesController < ApplicationController
  layout 'exiles'

  respond_to :html

  before_filter :find_search, only: [:show, :edit, :update]
  before_filter :view_layout, only: [:index, :new, :show, :create]

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
    update_from_url_params(@search)

    @searchable = Elastic::ExileSearch.new(@search, params)
    @tire_search = @searchable.tire_search
    @results = ExileDecorator.decorate_collection(@tire_search.results)
  end

  def update_from_url_params(search)
    klass_name = params[:class]
    unique_name = params[:unique]
    order = params[:order]

    klass_id = Klass.select("id").find_by(name: klass_name).try :id
    unique_id = Unique.select("id").find_by(name: unique_name).try :id

    attrs = {}

    attrs.merge!({ klass_ids: [klass_id] }) unless klass_name.nil?
    attrs.merge!({ unique_ids: [unique_id] }) unless unique_name.nil?
    attrs.merge!({ order: order }) unless order.nil?

    search.assign_attributes attrs
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
