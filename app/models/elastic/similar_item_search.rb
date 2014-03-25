class Elastic::SimilarItemSearch < Elastic::BaseSearch
  include Elastic::Concerns::Facets
  include Elastic::Concerns::Sort

  delegate :count, to: :stats, prefix: true

  attr_accessor :explanation, :search, :options

  def initialize(search, options = {})
    super
    @explanation = []
  end

  end

  def tire_search
    Tire.search(Indices.item_indices(search), tire_search_hash)
  end

  def tire_search_hash
    return @_tire_search_query if @_tire_search_query

    item = self

    @_tire_search_query = Tire::Search::Search.new do
      query { filtered {} }

      item.with_context(self) do
        item.facets unless item.item?
        item.paginate
        item.sort(score: true)
      end
    end

    @_tire_search_query.to_hash.tap do |query|
      query[:query][:filtered].update(boolean_query)
      query[:query][:filtered].update(filter_query)
    end
  end

  def filter_query
    item = self

    Tire::Search::Search.new do
      item.with_context(self) do
        filter :term, verified: true
        item.filter_match :corrupted if item.corrupted?
        item.filter_match :archetype

        filter :has_parent, item.online_player_query if item.online?
      end
    end.to_hash
  end

  def boolean_query
    item = self

    query = Tire::Search::Search.new do
      query do
        boolean do
          item.with_context(self) do
            item.item_specific_requirements if item.item?

            item.should_match_item_type

            item.is_priced

            case
            when  item.skill?; item.similar_skills
            when  item.map?  ; item.similar_maps
            else             ; item.similar_items
            end
          end
        end
      end
    end.to_hash

    query[:query][:bool].empty? ? find_all : query
  end

  def item_specific_requirements
    item = self.search
    context.must_not { term :id, item.id }
    context.must_not { term :account, item.account } if item.account.present?
  end

  def is_priced
    bool_query = item? ? :should : (search.has_price? ? :must : :should)
    context.send(bool_query) { string "_exists_:price.gcp OR _exists_:price.exa OR _exists_:price.alch OR _exists_:price.chaos", boost: 5 }
  end

  def minimum_number_should_match
    case
    when skill?; 0
    when map?  ; 0
    else
      if item?
        similar_stats_count
      else
        min = search.minimum_mod_match.to_i
        min > 0 ? min : similar_stats_count
      end
    end
  end

  def similar_stats_count
    return @similar_stats_count if @similar_stats_count

    @similar_stats_count = self.class.similar_stats_count(
      search, stats_count
    )
  end

  def self.similar_stats_count(search, stats_count)
    case stats_count
    when 0..2; stats_count
    when 3..5; stats_count - 1
    when 6..8; stats_count - 2
    else
      (stats_count * 0.6).to_i
    end
  end

  ### ITEMS

  def similar_items
    mods_should_match

    must_match :rarity_id
    @explanation << "Same rarity"

    similar_armour            if armour?
    similar_linked_sockets    if has_sockets?

    # maybe add a checkbox allowing to search for
    # better elemental damage?
    similar_elemental_damage  if weapon?

    similar_level

    if similar_stats_count == 0 || search.unique?
      @explanation << "Same rarity & base name"
      must_match :base_name
    end
  end

  def mods_should_match
    return unless stats_count > 0
    item = self

    context.must do
      boolean minimum_number_should_match: item.minimum_number_should_match do
        item.stats.each do |stat|
          bool_query = case
          when stat.required?; :must
          when stat.excluded?; :must_not
          else ;               :should
          end

          self.send(bool_query) do
            nested path: 'stats' do
              query do
                boolean do
                  must { term :mod_id, stat.mod_id }
                  if stat.value.present? && bool_query != :must_not
                    must { range :value, gte: stat.value } if stat.gte?
                    must { range :value, lte: stat.value } if stat.lte?
                  end
                end
              end
            end
          end
        end

      end
    end
  end

  def similar_armour
    [:evasion, :energy_shield, :armour].each do |type|
      if self.send(type).to_i > 0
        @explanation << "Has #{type.to_s.humanize}"
        context.must { range type, gt: 0 }
      end
    end
  end

  def similar_elemental_damage
    ele_dmg = elemental_damage.to_i
    return if ele_dmg == 0
    context.should { range :elemental_damage, gt: (ele_dmg * 0.9).to_i, boost: 2 }
  end

  def similar_linked_sockets
    return unless (linked_socket_count = self.linked_socket_count).present?
    @explanation << "Should have #{linked_socket_count} sockets or more"
    context.should { range :linked_socket_count, gte: linked_socket_count, boost: linked_socket_count }
  end

  def similar_level
    return unless (level = self.level).to_i > 0
    context.should { range :level,
      gte: (level.to_i * 0.8).to_i,
      lte: (level.to_i * 1.5).to_i,
      boost: 2
    }
  end

  ### SKILLS

  def similar_skills
    quality = self.quality.to_i
    same_base_name
    @explanation << "Quality should be higher"
    context.should { range :quality, gte: quality.to_i }
  end

  ### MAPS

  def similar_maps
    same_base_name
    similar_level
  end

  def same_base_name
    must_match :base_name
    @explanation << "Same base name"
  end

  ### OTHER

  def explanation
    @explanation.join("</br>")
  end

  def stats
    search.stats.tap do |stats|
      return stats.visible if stats.respond_to?(:visible)
    end
  end

  def should_match_item_type
    should_or_must = search.same_item_type? ? :must : :should

    @explanation << "#{should_or_must.to.capitalize} be of the same type"

    item_type = search.item_type
    context.send(should_or_must) do
      term :item_type, item_type
    end if item_type.present?

  end
end
