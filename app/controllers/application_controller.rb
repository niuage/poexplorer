class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :build_fast_search
  before_filter :find_broadcasts
  before_filter :store_location

  before_filter :configure_permitted_parameters, if: :configure_permitted_parameters?

  def build_fast_search
    @fast_search = FastSearch.new
  end

  def configure_permitted_parameters?
    !(self.class.name == "AuthenticationsController") && devise_controller?
  end

  def find_broadcasts
    @broadcasts = Broadcast.
      where('priority > 0').
      where('updated_at > ?', 1.day.ago).
      limit(5)
  end

  def view_layout
    @layout = ViewLayout.new(session[:layout_size], session[:layout_time], params)
    session[:layout_size] = @layout.layout_size
    session[:layout_time] = @layout.layout_time
  end

  def layout_size
    @layout.try(:size)
  end

  def store_location
    session["user_return_to"] = request.fullpath if !user_signed_in? && request.get? && !devise_controller? && !(request.url =~ /auth\//)
  end

  def user_league_id
    current_user.try :league_id
  end

  def default_league_id
    League.default_id
  end

  def current_league_id
    session[:current_league_id] || user_league_id.presence || default_league_id
  end
  helper_method :current_league_id

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      redirect_to(root_url, notice: exception.message)
    else
      redirect_to new_user_registration_path, notice: "Log in or sign up to access this page"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
  end
end
