class PlayersController < ApplicationController
  skip_before_filter :store_location

  before_filter :find_player, only: [:show, :edit, :update, :mark_online, :mark_offline, :destroy]
  before_filter :authorize_create, only: [:new, :create]
  before_filter :authorize_update, only: [:edit, :update, :mark_online, :mark_offline, :destroy]

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

    respond_with @player
  end

  def edit

  end

  def create
    @player = Player.new(params[:player]) do |p|
      p.account = current_user.account_name
    end

    @player.save

    respond_with @player, location: @player.errors.any? ? nil : current_user
  end

  def update
    @player.update_attributes(params[:player])
    @player.account = current_user.account_name

    @player.save

    respond_with current_user
  end

  def mark_online
    current_user  .players.reject { |p|
      p.id == @player.id
    }.each &:offline!

    @player.online!

    respond_with current_user
  end

  def mark_offline
    @player.offline!

    respond_with current_user
  end

  def destroy
    @player.destroy
    respond_with @player, location: user_url(current_user)
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
