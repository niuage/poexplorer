class SessionsController < Devise::SessionsController
  before_filter :view_layout

  layout "authentication"
end
