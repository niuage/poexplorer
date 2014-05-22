class UsersController < ApplicationController
  respond_to :html, :json

  before_filter :find_user, except: [:index, :update_layout]
  before_filter :authorize, except: [:index, :show, :update_layout]

  def index
    @users = User.page(params[:page]).per(20)
  end

  def show
    respond_with @user
  end

  def generate_token
    @user.generate_forum_token
    @user.save

    respond_with @user
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

  def update_layout
    view_layout
    render json: { success: true }
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
