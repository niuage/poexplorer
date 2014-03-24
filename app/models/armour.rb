class Armour < Item
  TYPES = G_ARMOUR_TYPES.freeze
  BASE_NAMES = G_ARMOUR_BASE_NAMES.freeze
  INDEX_NAMES = G_ARMOUR_INDEX_NAMES

  def armour?; true end
end
