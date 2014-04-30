module ExileExtensions::Mapping
  extend ActiveSupport::Concern

  included do
    include Tire::Model::Search

    after_touch   :update_index
    after_save    :update_index
    after_destroy :update_index

    tire do
      mapping do
        indexes :id, key: "value", index: :not_analyzed, included_in_all: false

        indexes :name, analyzer: 'snowball', boost: 50
        indexes :tagline, analyzer: 'snowball', boost: 20
        indexes :description, analyzer: 'snowball', boost: 10

        indexes :klass_id, type: "string", included_in_all: false
        indexes :klass_name, type: "string", index: :not_analyzed
        indexes :unique_ids, type: "string", included_in_all: false
      end
    end

    index_name "poe_exiles"
  end

  def to_indexed_json
    to_json(
      methods: [:user_login, :large_cover, :klass_name, :unique_ids],
      except: [:cached_photos, :items]
    )
  end
end
