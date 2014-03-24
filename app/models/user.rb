class User < ActiveRecord::Base
  include Concerns::Omniauth

  MAX_SHOP_COUNT = 3

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :league_id

  validates :login, presence: true, uniqueness: true

  # mount_uploader :avatar, AvatarUploader

  scope :admin, -> { where(role: "admin") }

  has_many :shops, dependent: :destroy

  has_many :user_favorites, dependent: :destroy
  has_many :favorite_items, -> { order("items.identified DESC") }, through: :user_favorites, source: :item

  has_many :user_players
  has_many :players, through: :user_players

  has_many :authentications

  has_many :builds

  belongs_to :league

  serialize :cached_favorite_item_ids

  before_save :cache_association_names

  make_voter

  def cache_association_names
    self.league_name = (self.league_id.nil? ? nil : self.league.name) if self.league_id_changed?
  end

  def cached_favorite_items
    Item.where(id: cached_favorite_item_ids)
  end

  def cached_favorite_item_ids
    self[:cached_favorite_item_ids] ||= []
    self[:cached_favorite_item_ids]
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

  def reached_shop_limit?
    shops.count >= MAX_SHOP_COUNT
  end

  def is?(user)
    user && id == user.id
  end

  def user_favorites_count
    cached_favorite_item_ids.length
  end

  def update_cached_favorite_item_ids
    update_attribute(:cached_favorite_item_ids, user_favorites.pluck(:item_id))
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
