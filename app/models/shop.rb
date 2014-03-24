class Shop < ActiveRecord::Base
  paginates_per 15

  # keys have to be columns
  # first is default
  SORT_BY = {
    indexed_at: "Indexed at",
    last_updated_at: "Thread updated at",
    created_at: "Shop created at",
    weapon_count: "Weapon count",
    armour_count: "Armour count",
    misc_count: "Misc count"
  }

  SORT_BY_COLUMNS = SORT_BY.keys.freeze

  attr_accessor :thread_url

  attr_accessible :thread_url, :notifications

  belongs_to :user
  belongs_to :league

  validates :title, presence: true,     if: :validate?
  validates :league, presence: true,    if: :validate?
  validates :username, presence: true,  if: :validate?

  validates :thread_url, presence: true, on: :create

  validates :user, presence: true
  validate :thread_id_presence

  before_validation :set_thread_id

  scope :valid,       -> { where('is_invalid IS NULL OR is_invalid = ?', false) }
  scope :invalid,     -> { where(is_invalid: true) }

  scope :visible,     -> { valid.where(processing: false) }
  scope :processing,  -> { valid.where(processing: true) }

  scope :scrawled_before, ->(delay) { where('indexed_at < ?', delay) }
  scope :in_league,       ->(league_id) { where(league_id: league_id) }
  scope :sort_by,         ->(sort) do
                            sort = Shop.sort_column(sort)
                            order("#{sort} DESC") if sort
                          end

  has_many :weapons
  has_many :armours
  has_many :miscs

  def thread_id_presence
    if !thread_id.present?
      errors.add(:thread_url, "is not valid")
    end
  end

  def set_thread_id
    return unless thread_url
    self.thread_id = thread_url.match(/(\d+)/).try(:[], 1)
  end

  def scrawled
    self.indexed_at = Time.zone.now
  end

  def visible?
    !processing? && !is_invalid?
  end

  def validate?
    visible?
  end

  def reset_counts
    self.weapon_count = 0
    self.armour_count = 0
    self.misc_count = 0
  end

  def self.sort_column(sort)
    return sort if SORT_BY_COLUMNS.map(&:to_s).include?(sort)
    SORT_BY_COLUMNS[0]
  end
end
