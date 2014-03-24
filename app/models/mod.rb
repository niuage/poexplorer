class Mod < ActiveRecord::Base
  attr_accessible :name
  attr_accessor :value

  POPULAR = "popular".freeze
  CUSTOM = "custom".freeze

  has_many :stats
  has_many :mod_item_types, dependent: :destroy

  def to_param
    name
  end

  def self.name_to_regexp(name)
    Regexp.new("^" << name.gsub("+", "\\\\+").gsub("#", "([-+]?[0-9]*\\.?[0-9]+)") << "$", "i")
  end

  def self.find_by_item_mod(item_mod)
    # might be a lot more efficient to transform
    # the item_mod into a base mod
    # and then do the search, and then get the value,
    # but hard because not every number is a variable

    # could transform ALL numbers into some pattern
    # then limit the search to those who match?

    G_MODIFIERS.each do |base_mod|
      regexp = Mod.name_to_regexp(base_mod)
      next unless values = regexp.match(item_mod)
      mod = find_by(name: base_mod)
      mod.value = get_value(values)
      return mod
    end
    nil
  end

  def self.get_value(values)
    case values.length
    when 2
      values[1].to_i
    when 3
      (values[1].to_i + values[2].to_i) / 2
    else
      nil
    end
  end

  def implicit?
    G_IMPLICIT_MODIFIERS[name].present?
  end
end
