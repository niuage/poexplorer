class UsersController < ApplicationController
  respond_to :html

  before_filter :find_user, except: [:index]
  before_filter :authorize, except: [:index, :show]

  def index
    @users = User.page(params[:page]).per(20)
  end

  def show
    @token = @user.forum_token if @user.is?(current_user)
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
      @token = @user.forum_token
      respond_with @user
    end
  end

  def validate_account
    return redirect_to(@user, notice: "The thread url was invalid") unless thread_id.to_i > 0

    thread = ForumThreadHtml.new(thread_id)

    return redirect_to(@user, notice: "The thread was invalid.") if thread.first_post.blank?

    return redirect_to(@user,
      notice: "You have to include '#{@user.forum_token}' in the first post of your thread"
    ) unless thread.first_post.match @user.forum_token

    account = thread.posted_by
    return redirect_to(@user, notice: "The thread was invalid. Could not find the account name.") if account.blank?

    @user.account = Account.where(name: account).first_or_initialize
    @user.save

    redirect_to @user, notice: "The account '#{account}'' was linked to this account successfully!"
  end

  private

  def thread_id
    return @thread_id if @thread_id.present?

    url = params[:user][:thread_url]
    url.gsub!(/\/?page(\/\d+)?/, "")
    return nil if url.blank?

    url = url.split("/").delete_if &:empty?

    @thread_id = url.last
  end

  def find_user
    @user = User.find(params[:id])
  end

  def authorize
    authorize! :update, @user
  end
end
