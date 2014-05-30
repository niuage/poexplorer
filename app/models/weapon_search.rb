class WeaponSearch < Search
  def weapon?; true end

  def generic_type?
    item_type.in? Weapon::GENERIC_NAMES.keys
  end

  def generic_type
    Weapon::GENERIC_NAMES[item_type]
  end
end
