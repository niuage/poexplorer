module Concerns
  module Omniauth
    extend ActiveSupport::Concern

    module ClassMethods
      def format_omniauth! o
        o.delete("extra")
      end
    end

    def update_omniauth_attributes omniauth, save = false
      user_info = omniauth['info']
      self.email = user_info['email'] if self.email.blank?
      self.login = user_info['nickname'] || user_info['name'] || omniauth_login(user_info) if self.login.blank?
      self.save if save
    end

    def omniauth_login info
      "#{info["first_name"]}#{ info["last_name"] if info["last_name"] }"
    end

    def apply_omniauth omniauth
      update_omniauth_attributes omniauth
      authentications.build do |auth|
        auth.provider = omniauth['provider']
        auth.uid = omniauth['uid']
      end
    end

    def create_authentication! omniauth
      authentications.create! do |auth|
        auth.provider = omniauth['provider']
        auth.uid = omniauth['uid']
      end
    end

    def unused_services
      Authentication::PROVIDERS.reject{|s| authentications.map(&:provider).include?(s.to_s) }
    end

  end
end
