module AuthenticationHelper

  def my_provider_path(provider)
    "/auth/#{provider.to_s}"
  end

  def simple_link_to_provider provider
    link_to "Sign in with #{provider.capitalize}", my_provider_path(provider), class: "#{provider} provider"
  end

  def link_to_provider provider, auth = nil
    provider_name = provider.capitalize

    if auth
      link_to authentication_path(auth), method: :delete, confirm: "Are you sure you want to remove this service?", class: "connected" do
        content_tag(:i, "", class: "icon-#{provider} icon-2x pull-left") + \
        "Disconnect from<br><span>#{provider_name}</span>".html_safe
      end
    else
      verb = user_signed_in? ? "Connect with" : "Login with"
      link_to my_provider_path(provider.to_sym) do
        content_tag(:i, "", class: "icon-#{provider} icon-2x pull-left") + \
        "#{verb}<br><span>#{provider_name}</span>".html_safe
      end
    end
  end

end
