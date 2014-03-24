module FormHelper
  def simple_options_for_select model_class, options = {}
    Rails.cache.fetch("simple_options_for_select_#{model_class}") do
      options.reverse_merge!({
        select: "id, name",
        text: ->(name) { name }
        })
      model_class.select(options[:select]).order('id ASC').all.map do |r|
        text = options[:text].call(r.name)
        text ? [text, r.id] : nil
      end.compact
    end
  end

  def item_types_for_mod(mod_name)
    G_MODIFIER_TYPES[mod_name].try(:join, " ")
  end

  def mod_select(item_archetype)
    Rails.cache.fetch("mod_select_#{item_archetype}") do
      item_type = ItemType.find_by(name: item_archetype)
      mods = item_type.mods.select("mods.id, mods.name, mod_item_types.mod_group")
      popular, others = mods.partition { |m| m.mod_group == Mod::POPULAR }
      custom, others = others.partition { |m| m.mod_group == Mod::CUSTOM }
      all_mods = [
        ["PoExplorer mods", custom.map { |mod| [mod.name, mod.id, class: item_types_for_mod(mod.name)] }],
        ["Popular mods", order_popular_mods(popular)],
        ["Other mods", others.map { |mod| [mod.name, mod.id, class: item_types_for_mod(mod.name)] }]
      ]
    end
  end

  def order_popular_mods(popular)
    popular.map { |mod| [G_POPULAR_MODIFIERS.index(mod.name), [mod.name, mod.id, class: item_types_for_mod(mod.name)]] }
    .sort { |a, b| a[0] <=> b[0] }
    .map { |mod| mod[1] }
  end

  def base_names_select_for_category(category_class)
    Rails.cache.fetch("base_names_select_#{category_class}") do
      category = category_class.name.downcase
      base_names_collection = []

      G_BASE_NAMES[category].each_pair do |type, base_names|
        base_names_collection.concat(base_names.map do |base_name|
          [base_name, base_name, { class: type }]
        end)
      end

      base_names_collection
    end
  end

  def item_types_select(item_type = Item)
    item_type::TYPES.map do |type|
      [ type.titleize, type.classify, { :"data-type" => type.underscore } ]
    end
  end
end
