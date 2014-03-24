class ItemType < ActiveRecord::Base
  TYPES = Item::TYPES.dup.concat(Item::ARCHETYPES)

  attr_accessible :name
  validates :name, inclusion: { in: TYPES }

  has_many :mod_item_types
  has_many :mods, through: :mod_item_types
end
