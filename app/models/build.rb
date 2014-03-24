class Build < ActiveRecord::Base
  include BuildExtensions::Mapping
  include BuildExtensions::Constants

  index_name "poe_builds"

  belongs_to :user
  validates :user, presence: true

  has_many :build_uniques
  has_many :uniques, through: :build_uniques

  has_many :build_classes, dependent: :destroy
  has_many :klasses, through: :build_classes
  validate :must_have_a_klass

  has_many :gears, dependent: :destroy
  accepts_nested_attributes_for :gears, allow_destroy: true, reject_if: :reject_gear?

  has_many :skill_gems, through: :gears

  has_many :skill_trees, dependent: :destroy
  accepts_nested_attributes_for :skill_trees, allow_destroy: true, reject_if: :reject_tree?

  has_one :bandit_choice, dependent: :destroy
  accepts_nested_attributes_for :bandit_choice, allow_destroy: true
  validates :bandit_choice, presence: true

  has_many :build_keystones, dependent: :destroy
  has_many :keystones, through: :build_keystones

  validates :title, presence: true, length: { minimum: 15, maximum: 75 }

  validates :summary, presence: true, length: { minimum: 50, maximum: 300 }, if: :to_publication?
  validates :description, presence: true, length: { maximum: 10000 }, if: :to_publication?

  attr_accessible :title, :summary, :description, :conclusion, :gearing_advice,
                  :video_url, :life_type,
                  :softcore, :hardcore, :pvp,
                  :klass_ids, :unique_ids, :keystone_ids,
                  :gears_attributes, :skill_trees_attributes, :bandit_choice_attributes

  make_voteable

  def published?
    persisted? && !published_at.nil?
  end

  def to_publication?
    !published_at.nil?
  end

  def publish
    self.published_at = Time.zone.now
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def description_value
    description.presence || description_example
  end

  def conclusion_value
    conclusion.presence || conclusion_example
  end

  def description_example
    "## About your build\n" \
    "Displayed first, be as comprehensive as possible!\n\n" \
    "## Normal/Cruel/Merciless\n" \
    "How to progress through Normal/Cruel/Merciless\n\n" \
    "## Strategies\n\n" \
    "## Etc"
  end

  def conclusion_example
    "This will be displayed at the end of the build\n\n" \
    "## Alternatives\n\n" \
    "## Conclusion"
  end

  def reject_tree?(tree)
    tree["url"].blank? && tree["description"].blank?
  end

  def reject_gear?(gear)
    return false if to_publication?
    gear["skill_gem_ids"].delete_if { |ids| ids.blank? }.empty? &&
      gear["description"].blank?
  end

  def must_have_a_klass
    if klasses.all? { |klass| klass.marked_for_destruction? }
      errors.add(:klass_ids, 'Must have at least one class')
    end
  end

  def disqus_id
    "build_#{id}"
  end
end
