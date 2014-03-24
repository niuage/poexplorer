class UsersController < ApplicationController
  respond_to :html

  before_filter :find_user, except: [:index]
  before_filter :authorize, except: [:index, :show]

  def index
    @users = User.page(params[:page]).per(20)
  end

  def show
    respond_with @user
  end

  def generate_token
    if @user.forum_token.blank?
      @user.generate_forum_token
      @user.save
    end

    respond_with @user, location: link_character_user_path(@user, ign: params[:user][:ign])
  end

  def link_character
    if (@ign = params[:ign]).blank?
      redirect_to @user, notice: "IGN missing"
    else
      @token = "#{@user.forum_token}:#{@ign}:"
      respond_with @user
    end
  end

  def validate_player
    thread_id = thread_id()
    return redirect_to(@user, notice: "The thread url was invalid") unless thread_id

    league = League.find((params[:user][:league_id].presence || League.permanent.first.id).to_i)

    thread = Nokogiri::HTML(open("http://pathofexile.com/forum/view-thread/#{thread_id}"))
    content = thread.css(".forumPostListTable tr:first-child .content").first.try(:inner_html)
    return redirect_to(@user, notice: "The thread was invalid.") if content.blank?

    matches = content.match Regexp.new("#{@user.forum_token}:([^:\s<]+):")
    character = matches && matches[1]
    return redirect_to(@user, notice: "The character name could not be found. You have to include '#{@user.forum_token}:character_name:' in your thread") if character.blank?

    account = thread.css(".forumPostListTable tr:first-child td:nth-child(2) .post_by_account a").first.try :text
    return redirect_to(@user, notice: "The thread was invalid. Could not find the account name.") if account.blank?

    player = Player.where(character: character, account: account).first_or_initialize

    if player.new_record?
      player.league = league
      player.online = false
    elsif @user.players.where(id: player.id).any?
      return redirect_to(@user, notice: "This character was already linked to your account.")
    end

    player.save
    @user.players << player

    redirect_to @user, notice: "#{character} (#{account}) was linked to this account successfully."
  end

  private

  def thread_id
    url = params[:user][:thread_url]
    return nil if url.blank?

    url = url.split("/").delete_if &:empty?

    return url.last
  end

  def find_user
    @user = User.find(params[:id])
  end

  def authorize
    authorize! :update, @user
  end
end
