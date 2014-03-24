class SimilarSearch < Search
  before_save :set_minimum_mod_match
  attr_accessor :force_minimum_mod_match

  def set_minimum_mod_match
    if (minimum_mod_match.blank? ||
        minimum_mod_match <= 0 ||
        force_minimum_mod_match)

      self.minimum_mod_match = Elastic::SimilarItemSearch.similar_stats_count(
        self, optional_stats_count
      )
    end

    if minimum_mod_match > optional_stats_count
      self.minimum_mod_match = optional_stats_count
    end

    self.minimum_mod_match = 0 if minimum_mod_match < 0

    if minimum_mod_match > stats_count
      self.minimum_mod_match = stats_count
    end
  end

  def same_item_type
    true if self[:same_item_type] || self[:same_item_type].nil?
  end

  def optional_stats_count
    stats.select { |s| s.mod_id && !s.required? && !s.excluded? }.count
  end

  def to_s
    archetype_name
  end

  def to_title
    archetype_name.pluralize
  end

  def archetype
    case
    when weapon?; 0
    when armour?; 1
    when misc?; 2
    end
  end

  def archetype_name
    case
    when weapon?; "Weapon"
    when armour?; "Armour"
    when misc?; "Misc"
    end
  end

  def unique?
    return false unless rarity
    rarity.name.downcase == "unique"
  end
end
