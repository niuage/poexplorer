class User < ActiveRecord::Base
  include UserExtensions::Omniauth
  # include UserExtensions::ShoppingCart

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :league_id

  validates :login, presence: true, uniqueness: true

  scope :admin, -> { where(role: "admin") }

  has_many :user_players
  has_many :players, through: :user_players
  has_many :authentications
  # has_many :builds
  belongs_to :league

  before_save :cache_association_names

  # make_voter

  def cache_association_names
    self.league_name = (self.league_id.nil? ? nil : self.league.name) if self.league_id_changed?
  end

  def to_param
    "#{id}-#{login.parameterize}"
  end

  def generate_forum_token
    self.forum_token = [*('a'..'z'),*('0'..'9')].shuffle[0, 20].join
  end

  def admin?
    role == "admin"
  end

  def disqus_id
    "user_#{id}"
  end

  def is?(user)
    user && id == user.id
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def league?
    self[:league_name].present?
  end

  def league_name
    self[:league_name].try(:capitalize)
  end
end
