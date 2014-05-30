class Item < ActiveRecord::Base
  include Extensions::SocketCombination
  include ItemExtensions::Price

  store :socket_store, accessors: [:sockets, :socket_count, :linked_socket_count], coder: JSON
  store :requirements, accessors: [:level, :str, :dex, :int], coder: JSON
  store :size, accessors: [:w, :h], coder: JSON
  store :display_stats, accessors: [:raw_physical_damage, :life, :mana, :resistance_count], coder: JSON

  MAX_SOCKET_COUNT = 6
  ARCHETYPES = ["Weapon", "Armour", "Misc"]
  TYPES = [G_WEAPON_TYPES, G_ARMOUR_TYPES, G_MISC_TYPES].flatten.freeze
  BASE_NAMES = [G_WEAPON_BASE_NAMES, G_ARMOUR_BASE_NAMES, G_MISC_BASE_NAMES].flatten.freeze
  GENERIC_NAMES = {}

  attr_accessible :name, :account, :type, :quality, :level,
    :verified, :identified, :league, :rarity, :rarity_id, :league_id,
    :sockets, :linked_socket_count, :socket_count, :socket_combination,
    :remote_icon_url, :base_name, :corrupted, :stats_attributes,
    :physical_damage, :critical_strike_chance, :aps, :str,
    :dex, :int, :dps, :thread_id,
    :raw_icon, :w, :h, :armour, :evasion, :energy_shield, :block_chance,
    :elemental_damage, :raw_physical_damage

  before_validation   :compute_elemental_damage, on: :create, if: :misc_with_elemental_damage?
  before_save         :cache_association_names

  validates :type, inclusion: { in: TYPES, message: "This item type does not exist." }
  validates :league, presence: true

  belongs_to  :league
  belongs_to  :rarity
  has_one     :search

  has_many    :stats, dependent: :destroy
  has_many    :mods, through: :stats

  # has_many    :user_favorites, dependent: :destroy

  scope :verified,    -> { where(verified: true) }
  scope :unverified,  -> { where(verified: false) }

  accepts_nested_attributes_for :stats, allow_destroy: true

  def cache_association_names
    self.league_name = (self.league_id.nil? ? nil : self.league.name) if self.league_id_changed?
    self.rarity_name = (self.rarity_id.nil? ? nil : self.rarity.name) if self.rarity_id_changed? #probably not necessary anymore
  end

  def misc_with_elemental_damage?
    self.class.to_s.in? ["Amulet", "Ring", "Quiver", "Glove", "Helmet", "BodyArmour", "Boot"]
  end

  def compute_elemental_damage
    self.elemental_damage = stats.inject(0) do |dmg, stat|
      dmg + ((stat.elemental_dps? && !stat.hidden) ? stat.value.to_i : 0)
    end
  end

  # INDEX

  # is this even necessary now that I customize update_index?
  def save(*)
    old_name = Thread.current[:current_league_id]
    Thread.current[:current_league_id] = league_id
    return_value = super
    Thread.current[:current_league_id] = old_name
    return_value
  end

  # END INDEX

  def physical_dps; nil end # ??

  def full_name
    "#{self.name || ""} #{self.base_name}"
  end

  def archetype
    [:weapon, :armour, :misc].each_with_index do |archetype, i|
      return i if self.send(:"#{archetype}?")
    end
    nil
  end

  # Interface
  def has_sockets?; true end
  def weapon?; false end
  def armour?; false end
  def misc?; false end
  def skill?; false end
  def map?; false end
  def unique?; rarity_name.try(:downcase) == "unique" end

  # for SimilarItemSearch
  # TODO: virer tout ca si je decide de creer un object
  # SimilarItemSearch quand on visite /items/21345
  def searchable_indices
    TireIndex.name(league_id)
  end
  def same_item_type?; true end
  def online?; false end
end
