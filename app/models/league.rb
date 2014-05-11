class League < ActiveRecord::Base
  LEAGUES = [
    "standard",
    "hardcore"
  ]

  SEASON_LEAGUES = [
    "anarchy",
    "onslaught",
    "domination",
    "nemesis",
    "ambush",
    "invasion",
    "2 Week Charity Event"
  ]

  MERGED_LEAGUES = ["2 Week Charity Event"]

  OLD_SEASON_LEAGUES = [
    "anarchy",
    "onslaught",
    "domination",
    "nemesis"
  ]

  after_save :update_all_items
  after_save :update_all_users

  has_many :items
  has_many :users

  has_many :players

  scope :permanent, -> { where(permanent: true) }
  scope :seasonal,  -> { where(permanent: false) }
  scope :visible,   -> { where('name NOT IN (?)', OLD_SEASON_LEAGUES) }

  def update_all_items
    items.update_all(league_name: self.name)
  end

  def update_all_users
    users.update_all(league_name: self.name)
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def self.visible?(name)
    !OLD_SEASON_LEAGUES.include?(name)
  end

  def self.running
    self.where(name: LEAGUES + SEASON_LEAGUES - OLD_SEASON_LEAGUES).all
  end

  def self.searchable_indices
    running.map { |league| TireIndex.name(league.id) }.join(",")
  end

  def self.default_id
    permanent.first.try :id
  end
end
