class ItemSorting
  ## When changing these values (keys),
  ## change also in ItemDecorator

  WEAPON_ORDER = {
    dps: "DPS",
    aps: "APS",
    physical_dps: "Physical DPS",
    physical_damage: "Physical Damage",
    elemental_damage: "Elemental Damage",
    linked_socket_count: "Linked Sockets",
    critical_strike_chance: "CS Chance"
  }

  ARMOUR_ORDER = {
    armour: "Armour",
    evasion: "Evasion",
    energy_shield: "Energy Shield",
    block_chance: "Block Chance",
    linked_socket_count: "Linked Sockets"
  }

  MISC_ORDER = {
    elemental_damage: "Elemental Damage",
    critical_strike_chance: "CS Chance"
  }

  SIMILAR_SEARCH_ORDER = {
    indexed_at: "Indexed at"
  }

  # for display
  DEFAULT_ORDER = {
    quality: "Quality",
    level: "Required Level"
  }

  SHARED_ORDER = DEFAULT_ORDER.merge({
    indexed_at: "Indexed at"
  })

  ORDER =  SHARED_ORDER
    .merge(WEAPON_ORDER)
    .merge(ARMOUR_ORDER)
    .merge(MISC_ORDER)

  attr_accessor :item, :context

  delegate :order, :order_by_mod_id,
  :item?, :weapon?, :armour?, :misc?,
  to: :item

  def initialize(item)
    self.item = item
  end

  def sort_by_mod_id
    return if (item? || (mod_id = order_by_mod_id.to_i) < 1)

    context.by "stats.value", {
      order: "desc",
      nested_filter: {
        term: { mod_id: mod_id }
      }
    }
  end

  def sort_by_score
    context.by :_score, "desc"
  end

  def sort_by_attributes
    return unless order.present?

    sort_weapon if weapon?
    sort_armour if armour?
    sort_misc   if misc?
    sort_shared
  end

  # def sort_weapon
  # def sort_armour
  # def sort_misc
  # def sort_shared
  [:weapon, :armour, :misc, :shared].each do |type|
    define_method "sort_#{type}" do
      context.by(order, 'desc') if send(:"valid_#{type}_order?")
    end
  end

  def default_sort
    context.by :indexed_at, 'desc'
  end

  def with_context(context, &block)
    old_context = self.context
    self.context = context
    yield
    self.context = old_context
  end

  private

  # def weapom_order?
  # def armour_order?
  # def misc_order?
  # def shared_order?
  [:weapon, :armour, :misc, :shared].each do |type|
    define_method("valid_#{type}_order?") { valid_order?(self.class.order_for_type(type)) }
  end

  def valid_order?(options)
    options[order].present?
  end

  class << self
    def order_for_type(type)
      "ItemSorting::#{type.upcase}_ORDER".constantize
    end

    # def weapon
    # def armour_collection
    # def misc_collection
    # def default_collection
    [:weapon, :armour, :misc, :default].each do |type|
      define_method("#{type}_collection") { collection_to_array order_for_type(type) }
    end

    def collection_to_array(collection)
      collection.to_a.map &:reverse
    end
  end

end
