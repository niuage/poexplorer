class AccountsController < ApplicationController
  skip_before_filter :store_location

  include Concerns::Search

  layout :layout_for_request
  respond_to :html, :json

  before_filter :view_layout, only: [:show]
  before_filter :find_account, only: [:show]

  def index
    respond_with do |format|
      format.html { redirect_to root_url }
      format.json do
        @players = Player.where(account: params[:account])

        league = params[:league].to_i
        @players = @players.where(league_id: league) if league > 0

        clean_up_players

        render json: @players
      end
    end
  end

  def show
    find_items_in_player_stash
    respond_with @account
  end

  def edit
    @user = User.find(params[:user_id])
    @account = @user.account
    authorize! :update, @account

    respond_with @account
  end

  private

  def find_account
    @account = Account.where(name: params[:id]).first_or_initialize
  end

  def find_items_in_player_stash
    @search = Search.new
    @search.account = @account.name
    update_from_url_params(@search)

    @results = ItemDecorator.decorate_collection(
      Elastic::PlayerStashSearch.new(@search, params).tire_search.results,
      context: { size: layout_size }
    )
  end

  def clean_up_players
    @players = @players.as_json
    @players.sort_by! { |p1, p2| p1["online"] ? 0 : 1 }.uniq! { |a| a["account"] }
  end

  def layout_for_request
    request.xhr? ? false : "application"
  end
end
