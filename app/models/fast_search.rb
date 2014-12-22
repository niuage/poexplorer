class FastSearch < ActiveRecord::Base
  include Extensions::Uid

  # remove!
  attr_accessible :query

  def searchable_indices
    TireIndex.name(league_id.presence || League.default_id)
  end

  def order
    "Indexed at"
  end
end
