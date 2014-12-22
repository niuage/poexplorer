module ItemExtensions::Mapping
  extend ActiveSupport::Concern

  included do
    after_touch   :my_update_index
    after_save    :my_update_index
    after_destroy :my_update_index

    include Tire::Model::Search

    alias_attribute :item_type, :type

    # see if using the option store: false could be more efficient
    # only data that I use in the view should be stored?
    tire do
      settings({
        analysis: {
          filter: {
            autocomplete_filter: {
              "type"     => "edge_ngram",
              "max_gram" => 10,
              "min_gram" => 1
            }
          },
          analyzer: {
            edge_ngram_analyzer: {
              "tokenizer"    => "standard", #standard?
              "filter"       => ["lowercase", "autocomplete_filter"], #standard, lowercase, #stop, #snowball?
              "type"         => "custom"
            }
          }
        }
      })

      mapping(
        _parent: { type: 'player' },
        _routing: { required: true, path: :account }
      ) do
        indexes :id,                            key: "value", index: :not_analyzed

        indexes :account,                       type: "string", index: :not_analyzed
        indexes :full_name,                     type: "string", analyzer: 'snowball', boost: 50
        indexes :name,                          type: "string", analyzer: "snowball", boost: 50
        indexes :ngram_full_name,               type: "string", index_analyzer: "edge_ngram_analyzer", search_analyzer: "standard", boost: 50
        indexes :base_name,                     type: "string", index: :not_analyzed

        indexes :archetype,                     type: "integer"
        indexes :item_type,                     type: "string", index: :not_analyzed

        indexes :aps,                           type: "float"
        indexes :dps,                           type: "float"
        indexes :physical_dps,                  type: "float"
        indexes :physical_damage,               type: "integer"
        indexes :elemental_damage,              type: "integer"
        indexes :edps,                          type: "float"
        indexes :csc,        type: "float"
        indexes :raw_physical_damage,           type: "string", index: :not_analyzed

        indexes :block_chance,                  type: "integer"
        indexes :armour,                        type: "integer"
        indexes :evasion,                       type: "integer"
        indexes :energy_shield,                 type: "integer"

        indexes :league_name,                   type: "string", index: :not_analyzed
        indexes :league_id,                     type: "integer"
        indexes :rarity_name,                   type: "string", index: :not_analyzed
        indexes :rarity_id,                     type: "integer"

        indexes :sockets,                       type: "object"
        indexes :socket_count,                  type: "integer"
        indexes :linked_socket_count,           type: "integer"
        indexes :socket_combination,            type: "string", analyzer: 'whitespace'

        indexes :quality,                       type: "integer"
        indexes :level,                         type: "integer"

        indexes :price,                         type: "object" do
          indexes :gcp, type: "float"
          indexes :alch, type: "float"
          indexes :chaos, type: "float"
          indexes :exa, type: "float"
        end

        indexes :h,                             type: "integer"
        indexes :w,                             type: "integer"

        indexes :level,                         type: "integer"
        indexes :str,                           type: "integer"
        indexes :int,                           type: "integer"
        indexes :dex,                           type: "integer"

        indexes :indexed_at,                    type: "date"

        indexes :verified,                      type: "boolean"
        indexes :identified,                    type: "boolean"
        indexes :sold,                          type: "integer"

        indexes :raw_icon,                      type: "string", index: :not_analyzed

        indexes :thread_updated_at,             type: "date"

        indexes :corrupted,                     type: "boolean"

        indexes :thread_id,                     type: "integer"

        indexes :stats, type: 'nested' do
          indexes :name,          type: "string", index: :not_analyzed
          indexes :value,         type: "integer"
          indexes :mod_id,        type: "integer", index: :not_analyzed
          indexes :hidden,        type: "boolean"
          indexes :implicit,      type: "boolean"
        end
      end
    end

  end

  def to_indexed_json
    to_json(
      include: { stats: { except: [
        :id,
        :item_id,
        :created_at,
        :updated_at
      ]}},
      except: [
        :type,
        :uid,
        :requirements,
        :display_stats,
        :socket_store,
        :icon,
        :size,
        :created_at,
        :updated_at
      ],
      methods: [
        :ngram_full_name,
        :indexed_at,
        :item_type,
        :archetype,
        :physical_dps,
        :edps,
        :full_name,
        :sockets, :socket_count, :linked_socket_count,
        :raw_physical_damage,
        :level, :str, :dex, :int,
        :w, :h
      ])
  end

  def index
    current_index.presence ||
      (Thread.current[:"poe_master_#{league_id}"] = Tire.index(index_name))
  end

  def current_index
    Thread.current[:"poe_master_#{league_id}"]
  end

  def my_update_index
      run_callbacks :update_elasticsearch_index do
        if destroyed?
          index.remove self
        else
          response = index.store(self, {
            parent: account,
            routing: account,
            percolate: percolator
          })
          tire.matches = response['matches'] if tire.respond_to?(:matches=)
          self
        end
      end
    end

  def index_name
    TireIndex.name(league_id)
  end
end
