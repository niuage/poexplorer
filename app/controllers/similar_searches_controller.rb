class SimilarSearchesController < ApplicationController
  respond_to :html

  before_filter :find_search, only: [:show, :update]
  before_filter :view_layout, only: [:show]

  def new
    @form = SimilarSearchFormDecorator.new(nil)
  end

  def show
    search
  end

  def create
    text = params[:similar_search][:text_representation]
    league_id = params[:similar_search][:league_id].presence || current_league_id

    if text.blank?
      flash[:alert] = "The text representation of the item can't be blank"
      return render(:new)
    end

    begin
      parser = ItemParser.new(text)
      search = parser.search
      search.update_attribute(:league_id, league_id)
    rescue TypeError => e
      flash[:alert] = e.message
      return render(:new)
    rescue ItemParsers::Base::InvalidSearchError => e
      flash[:alert] = e.message
      return render(:new)
    end

    respond_with search, location: similar_search_path(search)
  end

  def update
    @search.update_attributes(params[:similar_search])
    respond_with @search
  end

  private

  def search
    session[:current_league_id] = @search.league_id

    @searchable = Elastic::SimilarItemSearch.new(@search, params)
    @tire_search = @searchable.tire_search
    @results = ItemDecorator.decorate_collection(
      @tire_search.results,
      context: { size: layout_size }
    )
    @form = SimilarSearchFormDecorator.new(@search)
  end

  def find_search
    @search = Search.find_by(uid: params[:id])
  end

end
