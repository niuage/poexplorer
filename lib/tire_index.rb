class TireIndex
  INDEX_PREFIX = "poe_master"

  def self.league_index(league_id)
    Tire.index(name(league_id))
  end

  def self.name(league_id)
    [index_prefix, league_id].join("_")
  end

  def self.index_name(prefix, league_id)
    "poe_#{prefix}_#{league_id}"
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

  def self.create_index(prefix, league_id)
    raise ArgumentError.new("Prefix can't be blank") if prefix.blank?

    index = Tire.index(self.index_name(prefix, league_id))
    index.create(mappings: mappings, settings: {})

    a = Tire::Alias.new
    a.name self.name(league_id)
    a.index index.name
    a.save
  end

  def self.mappings
    Item::TYPES.first.constantize.tire.mapping_to_hash.merge(
      Player.tire.mapping_to_hash
    )
  end

  def self.delete_index(prefix, league_id)
    Tire.index(self.index_name(prefix, league_id)).delete
  end
end
