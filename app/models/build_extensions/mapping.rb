module BuildExtensions::Mapping
  extend ActiveSupport::Concern

  included do
    after_touch   :update_index

    include Tire::Model::Search

    after_save    :update_index
    after_destroy :update_index

    tire do
      mapping do
        indexes :id, key: "value", index: :not_analyzed
        indexes :user_id, key: "value", index: :not_analyzed
        indexes :username, index: :not_analyzed

        indexes :title, type: "string", analyzer: 'snowball'
        indexes :summary, type: "string", analyzer: 'snowball'
        indexes :description, type: "string", analyzer: 'snowball'
        indexes :gearing_advice, type: "string", analyzer: 'snowball'
        indexes :conclusion, type: "string", analyzer: 'snowball'

        indexes :life_type, type: "integer"
        indexes :softcore, type: "boolean"
        indexes :hardcore, type: "boolean"
        indexes :pvp, type: "boolean"

        indexes :published_at, type: "date"

        indexes :skill_gem_ids, type: "string"
        indexes :unique_ids, type: "string"
        indexes :klass_ids, type: "string"
        indexes :keystones_ids, type: "string"

        indexes :skill_gem_names, type: "string", index: :not_analyzed
        indexes :unique_names, type: "string", index: :not_analyzed
        indexes :klass_names, type: "string", index: :not_analyzed
        indexes :keystone_names, type: "string", index: :not_analyzed

        indexes :main_gear_gems, type: "string"

        indexes :votes, type: "integer"

        indexes :views, type: "integer"
      end
    end

  end

  def skill_gem_names
    skill_gems.pluck(:name)
  end

  def unique_names
    uniques.pluck(:name)
  end

  def klass_names
    klasses.pluck(:name)
  end

  def keystone_names
    keystones.pluck(:name)
  end

  def username
    user.login
  end

  def main_gear_gems
    gems = gears.main.first.try(:skill_gems)
    return [] unless gems
    gems.map { |g| [g.name, g.attr, g.support] }
  end

  def to_indexed_json
    to_json(
      include: {},
      except: [:video_url, :created_at],
      methods: [
        :skill_gem_ids, :unique_ids, :klass_ids, :keystone_ids,
        :skill_gem_names, :unique_names, :klass_names, :keystone_names,
        :main_gear_gems,
        :votes,
        :username
      ])
  end
end
