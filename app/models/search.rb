class Search < ActiveRecord::Base
  include Extensions::Uid

  attr_accessible :account, :item_type, :session, :order,
    :name, :quality, :verified, :identified,
    :league, :rarity, :rarity_id, :league_id,
    :sockets, :linked_socket_count, :socket_count, :max_linked_socket_count,
    :max_socket_count, :remote_icon_url, :base_name,
    :physical_dps, :physical_damage,
    :edps, :elemental_damage,
    :csc, :aps,
    :max_level, :level, :str, :dex, :int, :max_int, :max_dex, :max_str,
    :dps, :thread_id, :stats_attributes,
    :raw_icon, :w, :h,
    :armour, :evasion, :energy_shield, :block_chance,
    :max_armour, :max_evasion, :max_energy_shield, :max_block_chance,
    :raw_physical_damage,
    :price_value, :max_price_value, :currency, :socket_combination,
    :minimum_mod_match, :same_item_type, :has_price, :corrupted, :online,
    :order_by_mod_id, :sort_by_price, :damage, :max_damage

  attr_accessor :ngram_full_name, :damage, :max_damage

  belongs_to :league

  delegate :count, to: :stats, prefix: true

  has_many :stats, class_name: "SearchStat"
  accepts_nested_attributes_for :stats, allow_destroy: true, reject_if: ->(stat) { stat["mod_id"].blank? }

  belongs_to :rarity

  before_save :format_socket_combination, if: :format_socket_combination?

  def format_socket_combination?
    has_sockets? && socket_combination_changed?
  end

  def format_socket_combination
    self.socket_combination = SocketCollection.format_combination(socket_combination)
  end

  def searchable_indices
    TireIndex.name(league_id.presence || League.default_id)
  end
  alias_method :index_name, :searchable_indices # def index_name

  def has_sockets?
    !misc?
  end
  def weapon?
    item_type.try :in?, Weapon::TYPES
  end
  def armour?
    item_type.try :in?, Armour::TYPES
  end
  def misc?
    item_type.try :in?, Misc::TYPES
  end
  def skill?
    item_type.try :==, "Skill"
  end
  def map?
    item_type.try :==, "Map"
  end
  def generic_type?
    false
  end

  def to_s
    return "misc item" if misc?
    type.downcase.gsub("search", "")
  end

  def to_title
    return "Items" unless type.present?
    type.gsub("Search", "").pluralize
  end

  # integer, for indexing
  def archetype
    ["WeaponSearch", "ArmourSearch", "MiscSearch"].index self.class.to_s
  end

  def archetype_name
    type.try(:gsub, "Search", "") || "Weapon"
  end

  def full_name
    "#{self.name || ""} #{self.base_name}"
  end

  def model_name
    @model_name ||= self.class.name.underscore
  end
end
