class Armour < Item
  TYPES = G_ARMOUR_TYPES.freeze
  BASE_NAMES = G_ARMOUR_BASE_NAMES.freeze

  def armour?; true end
end
