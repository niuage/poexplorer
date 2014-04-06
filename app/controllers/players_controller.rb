class PlayersController < ApplicationController
  skip_before_filter :store_location

  before_filter :find_player, only: [:show, :edit, :update, :mark_online, :destroy]
  before_filter :authorize_create, only: [:new, :create]
  before_filter :authorize_update, only: [:edit, :update, :mark_online]

  layout :layout_for_request
  respond_to :html, :json

  def index
    @players = Player.where(character: params[:characters])

    respond_with do |format|
      format.json { render json: @players }
    end
  end

  def new
    @player = Player.new
    respond_with @player
  end

  def show
    @player = new_player if !@player

    respond_with @player do |format|
      format.json
      format.html do
        find_items_in_player_stash
      end
    end
  end

  def edit

  end

  def create
    @player = Player.new(params[:player])
    @player.account = current_user.account_name

    @player.save

    respond_with current_user
  end

  def update
    @player.update_attributes(params[:player])
    @player.account = current_user.account_name

    @player.save

    respond_with current_user
  end

  def mark_online
    current_user.players.each &:offline!
    @player.online!

    respond_with current_user
  end

  private

  def new_player
    Player.new do |p|
      p.account = params[:id]
    end
  end

  def layout_for_request
    request.xhr? ? false : "application"
  end

  def find_player
    @player = Player.find_by(character: params[:id])
  end

  def authorize_create
    authorize! :create, Player
  end

  def authorize_update
    authorize! :update, @player
  end
end
