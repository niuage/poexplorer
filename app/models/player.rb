class Player < ActiveRecord::Base
  include PlayerExtensions::Mapping

  ONLINE_DURATION = 1.5.hours

  attr_accessible :league_id, :character, :online

  belongs_to :league

  validates :account,   presence: true
  validates :account,   uniqueness: { scope: :character }
  validates :character, presence: true, uniqueness: true
  validates :online,    inclusion: { in: [true, false] }
  validates :league_id, presence: true

  scope :online,  -> { where(online: true) }
  scope :offline, -> { where(online: false) }

  scope :not_marked_online, -> { where("marked_online_at IS NULL OR marked_online_at < ?", ONLINE_DURATION.ago) }
  scope :updated_before,    ->(time) { where('updated_at < ?', time) }
  scope :updated_after,     ->(time) { where('updated_at > ?', time) }

  scope :by_league,    ->(league_id) { where(league_id: league_id) }
  scope :by_character, ->(character) { where(character: character) }
  scope :by_account,   ->(account) { where(account: account) }

  scope :in_league, ->(league_id) { where(league_id: league_id) }

  # not working, can't figure out why
  belongs_to :poe_account, primary_key: "account", foreign_key: "name", class_name: "Account"

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
    options[:methods] << :marked_as_online
    super(options)
  end

  def last_online_iso8601
    last_online.try :iso8601
  end

  def online!
    self.online = true
    self.marked_online_at = Time.zone.now
    self.last_online = Time.zone.now
    save
  end
  def offline!
    self.online = false
    self.marked_online_at = nil
    save
  end

  def self.mark_offline(players, league_id = nil)
    return unless players

    players.update_all(
      online: false,
      marked_online_at: nil,
      updated_at: Time.zone.now
    )

    if league_id
      TireIndex.store(league_id, players)
    else
      players = players.to_a.sort_by! &:league_id
      chunks = players.chunk(&:league_id)
      chunks.each do |league_id, players|
        TireIndex.store(league_id, players)
      end
    end
  end

  def to_param
    character
  end

  def marked_as_online
    marked_online_at && marked_online_at > ONLINE_DURATION.ago
  end

  private

  def blank_character?
    character.blank?
  end
end
