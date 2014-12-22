#add index by frameType
class Rarity < ActiveRecord::Base
  FRAME_TYPES = [
    { name: "Normal", frame_type: 0 },
    { name: "Magic", frame_type: 1 },
    { name: "Rare", frame_type: 2 },
    { name: "Unique", frame_type: 3 },
    { name: "Gem", frame_type: 4 }
  ]

  attr_accessible :name
  has_many :items
  after_save :update_all_items
  scope :by_frame_type, ->(frame_type) { where(frame_type: frame_type) }

  def update_all_items
    items.update_all(rarity_name: self.name)
  end

  def self.name_to_frame_type(name)
    FRAME_TYPES.find { |t| t[:name] == name }[:frame_type]
  end
end
