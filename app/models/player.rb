class Player < ActiveRecord::Base
  include PlayerExtensions::Mapping

  belongs_to :league

  validates :account,   presence: true, uniqueness: { scope: :character }
  validates :online,    inclusion: { in: [true, false] }
  validates :league_id, presence: true
  validates :character, uniqueness: true

  scope :online,  -> { where(online: true) }
  scope :offline, -> { where(online: false) }

  scope :not_marked_online, -> { where("marked_online_at IS NULL OR marked_online_at < ?", 2.hours.ago) }
  scope :updated_before,    ->(time) { where('updated_at < ?', time) }
  scope :updated_after,     ->(time) { where('updated_at > ?', time) }

  scope :by_league,    ->(league_id) { where(league_id: league_id) }
  scope :by_character, ->(character) { where(character: character) }
  scope :by_account,   ->(account) { where(account: account) }

  scope :in_league, ->(league_id) { where(league_id: league_id) }

  def self.create_from_api(player_data, league_id, version = 0)
    character_name = player_data["character"]["name"]
    account_name = player_data["account"]["name"]

    if Player.by_league(league_id).by_character(character_name).exists?
      return "NOT CREATED #{account_name} > #{character_name}"
    end

    player = Player.create do |player|
      player.character = character["name"]
      player.account = player_data["account"]["name"]
      player.league_id = league_id
      player.online = player_data["online"]
    end

    "player created #{player.account} > #{player.character}"
  end

  def self.create_all_from_api(players_data, league_id)
    formatted_data = players_data.map do |player|
      [
        player["account"]["name"],
        player["character"]["name"],
        league_id,
        player["online"],
        player["online"] ? Time.zone.now : nil
      ]
    end

    self.import(
      [:account, :character, :league_id, :online, :last_online],
      formatted_data
    )
  end

  def as_json(options)
    options[:except] ||= []
    options[:except] << :last_online

    options[:methods] ||= []
    options[:methods] << :last_online_iso8601
    super(options)
  end

  def last_online_iso8601
    last_online.try :iso8601
  end

  ### remove? ###
  SORT_BY = {
    online: "Online",
    rank: "Rank"
  }

  SORT_BY_COLUMNS = SORT_BY.keys.freeze

  scope :sort_by, ->(sort) do
    sort = Player.sort_column(sort)
    direction = { rank: "ASC", online: "DESC" }
    order("#{sort} #{direction[sort]}") if sort
  end

  def self.sort_column(sort)
    return sort if SORT_BY_COLUMNS.map(&:to_s).include?(sort)
    SORT_BY_COLUMNS[0]
  end
  ### end remove? ###

  def online!
    update_columns(online: true, last_online: Time.zone.now)
  end
  def offline!
    update_attribute :online, false
  end
end
