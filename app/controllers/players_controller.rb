class PlayersController < ApplicationController
  include Concerns::Search

  before_filter :view_layout, only: [:show]
  skip_before_filter :store_location

  layout :layout_for_request
  respond_to :html, :json

  def index
    respond_to do |format|
      format.json do
        # I should also take into account the league
        # but it would require a query per player I think
        # since they are potentially from different leagues
        @players = Player.where(account: params[:account])

        league = params[:league].to_i
        @players = @players.where(league_id: league) if league > 0

        render json: @players
      end
      format.html do
        @players = Player.page(params[:page]).per(20)
        @league_id = (params[:league].presence || user_league_id.presence || League.first.try(:id)).to_i
        @players = @players.in_league(@league_id) if @league_id > 0
        @players = @players.sort_by(params[:sort])
      end
    end
  end

  def show
    @player = Player.find_by(account: params[:id])
    if !@player
      @player = Player.new
      @player.account = params[:id]
    end
    respond_with @player do |format|
      format.json
      format.html do
        find_items_in_player_stash
      end
    end
  end

  private

  def layout_for_request
    request.xhr? ? false : "application"
  end

  def find_items_in_player_stash
    @search = Search.new
    @search.account = @player.account
    update_from_url_params(@search)

    @results = ItemDecorator.decorate_collection(
      Elastic::PlayerStashSearch.new(@search, params)
      .tire_search
      .results
      )
  end

end
