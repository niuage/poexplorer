class StatBuilder
  attr_reader :item, :implicit_mods, :explicit_mods, :resistances, :search_stat
  attr_accessor :implicit_mod

  @@unknown_mods = {}
  @@missing_types_mods = {}

  def initialize(item, implicit_mods = nil, explicit_mods = nil, search_stat = false)
    @item = item
    @implicit_mods = implicit_mods || []
    @explicit_mods = explicit_mods || []
    @implicit_mod = nil
    @search_stat = search_stat
    @resistances = {
      "lightning" => 0,
      "cold" => 0,
      "fire" => 0,
      "chaos" => 0
    }
  end

  def build
    implicit_mods.each { |raw_mod| build_stat(raw_mod, true) }
    explicit_mods.each { |raw_mod| build_stat(raw_mod) }
    save_custom_stats
  end

  def build_stat(raw_mod, implicit = false)
    mod = Mod.find_by_item_mod(raw_mod)

    if Rails.env.production?
      return unless mod
    else
      if !mod
        log_missing_mod(raw_mod)
        return
      elsif !G_MODIFIER_TYPES[mod.name].include?(item.type.underscore.to_sym)
        log_missing_mod(raw_mod, true)
      end
    end

    @implicit_mod ||= mod if implicit

    stat = item.stats.build(
      name: raw_mod,
      mod: mod,
      value: mod.value,
      implicit: implicit
    )

    update_custom_stats(stat) unless search_stat
  end

  def update_custom_stats(stat)
    update_custom_resistance_stats(stat)
  end

  def update_custom_resistance_stats(stat)
    if element = stat.elemental_resistance.try(:[], 1)
      resistances[element.downcase] += stat.value
    elsif chaos = stat.chaos_resistance.try(:[], 1)
      resistances["chaos"] += stat.value
    elsif stat.all_resistance?
      resistances.each do |elt, res|
        resistances[elt] += stat.value if elt != "chaos"
      end
    end
  end

  def save_custom_stats
    save_resistance_stats
    sum_duplicated_stats
  end

  def save_resistance_stats
    resistance_values = resistances.values

    resistance_count = resistance_values.delete_if { |v| v.zero? }.count
    resistance_total = resistance_values.sum

    resistance_count_stat(value: resistance_count) unless resistance_count.zero?
    resistance_total_stat(value: resistance_total) unless resistance_total.zero?
  end

  def sum_duplicated_stats
    return if !implicit_mod
    item.stats.each_with_index do |stat, i|
      next if i == 0 || stat.implicit || stat.hidden
      return build_sum_stat(implicit_mod, stat) if stat.mod_id == implicit_mod.id
    end
  end

  # improve (why the need to pass the implicit mod?)
  def build_sum_stat(implicit_mod, stat)
    # begin
    value = implicit_mod.value
    options = {}.tap do |opts|
      opts[:value] = implicit_mod.value + stat.value if implicit_mod.value
    end
    custom_stat_for_mod implicit_mod, options
    # rescue StandardError => e
    #   Bugsnag.notify(StandardError.new("build_sum_stat failed"), {
    #     implicit_mod: implicit_mod.inspect,
    #     implicit_mod_value: implicit_mod.value,
    #     stat: stat.inspect
    #   })
    #   raise e
    # end
  end

  # RESISTANCES

  def resistance_count_stat(options = {})
    resistance_count_mod = Mod.find_by(name: "Has # Resistances")
    custom_stat_for_mod(resistance_count_mod, options)
  end

  def resistance_total_stat(options = {})
    resistance_total_mod = Mod.find_by(name: "Adds a total of #% to Resistances")
    custom_stat_for_mod(resistance_total_mod, options)
  end

  private

  def stat_name_from_mod(mod, value)
    name = mod.name.gsub("#", value.to_s) if mod && value
  end

  def custom_stat_for_mod(mod, options = {})
    name = stat_name_from_mod(mod, options[:value])
    item.stats.build({
      name: name,
      mod_id: mod.id,
      hidden: true
    }.merge(options))
  end

  def log_missing_mod(raw_mod, missing_type = false)
    return if item.type.in?(["Skill", "Map", "Flask"])

    generic_mod = raw_mod.gsub(/([0-9]*\.?[0-9]+)/, "#")
    regexp = Regexp.new("^" << raw_mod.gsub("+", "\\\\+").gsub(/[0-9]*\.?[0-9]+/, "([0-9]*\\.?[0-9]+)") << "$", "i")
    values = regexp.match raw_mod

    item_type = item.type.underscore.to_sym

    if missing_type
      @@missing_types_mods[generic_mod] ||= []
      if !@@missing_types_mods[generic_mod].include?(item_type)
        @@missing_types_mods[generic_mod] << item_type
      end
    else
      @@unknown_mods[generic_mod] ||= []
      if !@@unknown_mods[generic_mod].try(:include?, item_type)
        @@unknown_mods[generic_mod] << item_type
      end
    end

    File.open("/tmp/unknown_mods.txt", "w") do |f|
      f << @@unknown_mods.select { |k, v| v.present? }
    end

    File.open("/tmp/missing_types.txt", "w") do |f|
      f << @@missing_types_mods.select { |k, v| v.present? }
    end
  end

end
