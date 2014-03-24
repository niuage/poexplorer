class Indices
  def self.item_indices(searchable)
    indices(searchable) + "/item"
  end

  def self.player_indices(indices)
    indices(searchable) + "/player"
  end

  def self.indices(searchable)
    raise TypeError unless searchable.respond_to?(:searchable_indices)
    searchable.searchable_indices
  end
end
