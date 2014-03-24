class ArmourSearchFormDecorator < SearchFormDecorator
  def item_types_select
    h.item_types_select(Armour)
  end

  def base_names_select
    h.base_names_select_for_category(Armour)
  end

  def order_options
    ItemSorting.armour_collection
  end

  def armour?; true end

  def to_partial_path
    "items/armour_fields"
  end
end
