class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env["omniauth.auth"]
    User.format_omniauth! omniauth
    auth = Authentication.find_by(provider: omniauth['provider'], uid: omniauth['uid'])
    if auth && (user = auth.user)
      user.remember_me = true
      sign_in_and_redirect(:user, user)
    elsif user_signed_in?
      current_user.update_omniauth_attributes omniauth, true
      current_user.create_authentication! omniauth
      flash[:notice] = t("authentication.create.success", provider: omniauth['provider'])
      redirect_to edit_user_registration_path
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        user.remember_me = true
        sign_in_and_redirect(:user, user)
      else
        flash[:notice] = "Fix the errors in the form below to create your new account, linked to your #{omniauth['provider'].capitalize} account."
        session[:omniauth] = omniauth
        redirect_to new_user_registration_url
      end
    end
  end

  def destroy
    authentications = current_user.authentications
    if authentications.count == 1 && current_user.encrypted_password.blank?
      flash[:error] = t "authentication.destroy.add_password"
    else
      authentication = authentications.find(params[:id])
      if !authentication || ((provider = authentication.provider) && !authentication.destroy)
        flash[:error] = t "authentication.destroy.error"
      else
        flash[:notice] = t "authentication.destroy.success", provider: provider
      end
    end
    redirect_to edit_user_registration_path
  end

  def devise_controller?
    true
  end
end
