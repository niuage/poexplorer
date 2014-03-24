class Admin::AdminController < ::ApplicationController
  layout "admin"

  before_filter :verify_admin

  def index

  end

  protected

  def verify_admin
    if !user_signed_in? || !current_user.admin?
      raise CanCan::AccessDenied.new("You are not authorized to view that page.", :manage, "Admin")
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message if user_signed_in?
    redirect_to new_user_session_path, alert: "You must log in to access that page" unless user_signed_in?
  end
end
