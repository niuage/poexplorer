class WeaponSearchFormDecorator < SearchFormDecorator
  def item_physical_damage(options = {})
    input :physical_damage, input_options({}, options)
  end

  def item_elemental_damage(options = {})
    input :elemental_damage, input_options({}, options)
  end

  def item_aps(options = {})
    input :aps, input_options({}, options)
  end

  def item_dps(options = {})
    input :dps, input_options({}, options)
  end

  # physical_dps is on the search object
  def item_physical_dps(options = {})
    input :physical_dps, input_options({}, options)
  end

  def item_csc(options = {})
    input :csc, input_options({}, options)
  end

  def item_types_select
    h.item_types_select(Weapon)
  end

  def base_names_select
    h.base_names_select_for_category(Weapon)
  end

  def order_options
    ItemSorting.weapon_collection
  end

  # delegate?
  def weapon?; true end

  def to_partial_path
    "items/weapon_fields"
  end
end
