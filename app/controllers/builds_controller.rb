class BuildsController < ApplicationController

  respond_to :html, :js, :json

  before_filter :find_build, only: [:show, :edit, :update, :destroy, :vote_up, :vote_down]
  before_filter :authorize_read, only: [:show]
  before_filter :authorize_creation, only: [:new, :create, :vote_up, :vote_down]
  before_filter :authorize_update, only: [:edit, :update]

  def index
    redirect_to build_searches_url
  end

  def show
    # increment_views # cant do that before indexing in the background
    @build = BuildDecorator.decorate(@build)
  end

  def new
    @build = Build.new
    @build.gears.build
    @build.skill_trees.build
    @build.build_bandit_choice
  end

  def vote_up
    return unless @build.valid?
    current_user.up_vote!(@build)
    respond_with @build do |format|
      format.json { render json: { count: @build.votes } }
    end
  end

  def vote_down
    return if !@build.valid? || @build.votes <= 0
    current_user.down_vote!(@build)
    respond_with @build do |format|
      format.json { render json: { count: @build.votes } }
    end
  end

  def load_votes
    if user_signed_in? && (ids = params[:ids]) && ids.any?
      json = MakeVoteable::Voting.where(voteable_id: ids, voter_id: current_user.id).map do |v|
        { id: v.voteable_id, upvote: v.up_vote }
      end
    else
      json = {}
    end

    respond_with @build do |format|
      format.json { render json: { votes: json } }
    end
  end

  def edit
    @build.build_bandit_choice unless @build.bandit_choice
  end

  def create
    @build = Build.new(params[:build]) do |build|
      build.user = current_user
      build.publish if publish?
      build.indexed = true
    end
    @build.save
    respond_with @build
  end

  def update
    @build.publish if publish?
    @build.indexed = true
    @build.update_attributes(params[:build])

    respond_with @build, location: @build.errors.any? ? nil : @build
  end

  private

  def authorize_creation
    authorize! :create, Build
  end
  def authorize_update
    authorize! :update, @build
  end
  def authorize_read
    authorize! :read, @build
  end

  def find_build
    @build = Build.find_by(id: params[:id])
    return redirect_to(root_url, notice: "This build could not be found, sorry.") unless @build
  end

  def publish?
    params[:commit] == "Publish your build"
  end

  def increment_views
    session[:build_views] ||= []
    unless session[:build_views].include?(@build.id)
      session[:build_views] << @build.id
      @build.increment!(:views)
    end

  end

end
