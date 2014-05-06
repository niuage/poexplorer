class ExilesController < ApplicationController
  layout :layout

  respond_to :html, :json

  before_filter :view_layout, only: [:new, :show]

  before_filter :authorize_create, only: [:new, :create, :vote_up]
  before_filter :find_exile, only: [:show, :edit, :update, :destroy, :vote_up]
  before_filter :set_update_album, only: [:update, :vote_up]
  before_filter :authorize_update, only: [:edit, :update, :destroy]

  def index
    redirect_to exile_searches_url
  end

  def new
    @exile = Exile.new
  end

  def edit
  end

  def show
    session[:view_exile] ||= []
    if !session[:view_exile].include? @exile.id
      session[:view_exile] << @exile.id
      @exile.update_column(:views, @exile.views.to_i + 1)
      @exile.update_index if rand(5) == 0
    end
  end

  def create
    @exile = Exile.create(exile_params) do |exile|
      exile.user = current_user
      exile.update_album = true
    end

    if @exile.errors.any?
      render :edit
    else
      respond_with @exile
    end
  end

  def update
    @exile.update_attributes(exile_params)

    respond_with @exile
  end

  def destroy

  end

  def vote_up
    current_user.up_vote!(@exile)
    respond_with @exile do |format|
      format.json { render json: { count: @exile.votes } }
    end
  end

  def load_votes
    if user_signed_in? && (ids = params[:ids]) && ids.any?
      votes = MakeVoteable::Voting.where(
        voteable_type: "Exile", voteable_id: ids,
        voter_id: current_user.id
      ).map do |v|
        { id: v.voteable_id, upvote: v.up_vote }
      end
    else
      votes = {}
    end

    respond_with @exile do |format|
      format.json { render json: { votes: votes } }
    end
  end

  private

  def exile_params
    params[:exile]
  end

  def find_exile
    @exile = Exile.find(params[:id])
  end

  def authorize_update
    authorize! :update, @exile
  end

  def authorize_create
    authorize! :create, Exile
  end

  def set_update_album
    @exile.update_album = true
  end

  def layout
    if action_name == "show"
      "exile_show"
    else
      "exiles"
    end
  end
end
