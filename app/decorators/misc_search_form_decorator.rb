class MiscSearchFormDecorator < SearchFormDecorator
  def item_elemental_damage(options = {})
    input :elemental_damage, input_options({}, options)
  end

  def item_types_select
    h.item_types_select(Misc)
  end

  def base_names_select
    h.base_names_select_for_category(Misc)
  end

  def order_options
    ItemSorting.misc_collection
  end

  def misc?; true end

  def to_partial_path
    "items/misc_fields"
  end
end
