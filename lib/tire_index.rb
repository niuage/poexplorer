class TireIndex
  INDEX_PREFIX = "poe_master"

  def self.league_index(league_id)
    Tire.index(name(league_id))
  end

  def self.name(league_id)
    [index_prefix, league_id].join("_")
  end

  def self.alias(league_id)
    Tire::Alias.find(name(league_id)).presence || Tire::Alias.new
  end

  def self.index_prefix
    INDEX_PREFIX
  end

  def self.store(league_id, models)
    league_index(league_id).bulk_store(models)
  end
end
