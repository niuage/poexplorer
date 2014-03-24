class RegistrationsController < Devise::RegistrationsController

  layout "authentication", except: [ :edit, :update ]

  def create
    super
    session[:omniauth] = nil unless resource.new_record?
  end

  def edit
    @authentications = resource.authentications
    super
  end

  def update
    params[resource_name].delete(:password) && params[resource_name].delete(:password_confirmation) if params[resource_name][:password].blank?
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render :edit
    end
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      resource.apply_omniauth(session[:omniauth])
      resource.valid?
    end
  end

  protected

  def after_update_path_for(resource)
    user_path(resource)
  end
end
