class Authentication < ActiveRecord::Base

  attr_accessible :uid, :provider

  belongs_to :user

  scope :facebook, -> { where(provider: "facebook") }
  scope :twitter, -> { where(provider: "twitter") }

  PROVIDERS = [
    { :name => :facebook, :klass => "facebook" },
    { :name => :twitter, :klass => "twitter" }
  ]

  def provider_name
    provider.titleize
  end

  def self.authentication_for_service(auths, provider)
    return if !auths
    auths.find{ |auth| auth.provider == provider.to_s }
  end
end
