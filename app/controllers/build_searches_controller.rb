class BuildSearchesController < ApplicationController
  include Concerns::BuildSearch

  respond_to :html

  def index
    search
    render :new
  end

  def show
    search
  end

  def new
    search
  end

  def create
    @search = BuildSearch.new(params[:build_search])
    @search.user = current_user if user_signed_in?

    @search.save

    search if !@search.valid?

    respond_with @search, location: location
  end

  def update
    @search.update_attributes(params[:build_search])
    search if !@search.valid?

    respond_with @search, location: location
  end

end
