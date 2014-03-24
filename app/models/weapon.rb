class Weapon < Item
  TYPES = G_WEAPON_TYPES.freeze
  BASE_NAMES = G_WEAPON_BASE_NAMES.freeze
  INDEX_NAMES = G_WEAPON_INDEX_NAMES

  before_validation :compute_damage, on: :create

  def weapon?; true end

  def compute_damage
    compute_elemental_damage
    dps = physical_damage.to_i + self.elemental_damage.to_i
    self.dps = dps * aps
  end

  def physical_dps
    (physical_damage.to_i * aps.to_f).to_i
  end

end
