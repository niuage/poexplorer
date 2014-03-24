module PlayerExtensions
  module Mapping
    extend ActiveSupport::Concern

    included do
      include Tire::Model::Search

      after_touch   :update_index
      after_save    :update_index
      after_destroy :update_index

      alias_attribute :_id, :account

      tire do
        mapping(_routing: { required: true, path: "account" }) do
          indexes :_id, path: "account", type: "string", index: :not_analyzed
          indexes :account, type: "string", index: :not_analyzed
          indexes :online, type: "boolean"
          indexes :league_id, type: "integer"
          indexes :marked_online_at, type: "date"
        end
      end

      index_name { TireIndex.name(Thread.current[:player_league_id]) }
    end

    def to_indexed_json
      to_json(
        methods: [:_id],
        except: [
          :id,
          :marked_online_at,
          :last_online,
          :created_at,
          :updated_at
        ]
        )
    end

    def save(*)
      old_name = Thread.current[:player_league_id]
      Thread.current[:player_league_id] = league_id
      return_value = super
      Thread.current[:player_league_id] = old_name
      return_value
    end

    def index
      current_index.presence || (Thread.current[:"poe_master_#{league_id}"] = Tire.index(index_name))
    end

    def current_index
      Thread.current[:"poe_master_#{league_id}"]
    end

    def index_name
      TireIndex.name(league_id)
    end

  end
end
