class Weapon < Item
  TYPES = G_WEAPON_TYPES.freeze
  BASE_NAMES = G_WEAPON_BASE_NAMES.freeze

  ONE_HANDERS = [
    "Claw",
    "Dagger",
    "OneHandAxe",
    "OneHandMace",
    "OneHandSword",
    "ThrustingOneHandSword",
    "Wand"
  ]

  TWO_HANDERS = TYPES - ONE_HANDERS

  GENERIC_NAMES = {
    "Any One-Handed Weapon" => ONE_HANDERS,
    "Any Two-Handed Weapon" => TWO_HANDERS
  }

  before_validation :compute_dps, on: :create

  def weapon?; true end

  def compute_dps
    self.dps = damage * aps
  end

  def physical_dps
    (physical_damage.to_i * aps.to_f).to_i
  end

  def edps
    elemental_damage * aps
  end
end
