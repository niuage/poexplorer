class Stat < ActiveRecord::Base
  attr_accessible :name, :value, :hidden, :implicit
  attr_accessible :mod, :mod_id
  attr_accessible :item, :item_id

  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }

  # not sure I need that actually, stats never change
  # and it gets really expensive to destroy an item
  belongs_to :item #, touch: true
  belongs_to :mod

  validates :mod, presence: true

  include StatExtensions::Stat

  # to match the SearchStat interface
  # for the SimilarItemSearch
  def required?; false end
  def excluded?; false end
  def gte?; false end
  def lte?; false end
end
