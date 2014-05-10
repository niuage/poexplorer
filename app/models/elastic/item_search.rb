class Elastic::ItemSearch < Elastic::BaseItemSearch
  include Elastic::Concerns::Sort
  include Elastic::Concerns::Facets
  include Elastic::Concerns::Item

  attr_accessor :any_type

  def tire_search
    Tire.search(Indices.item_indices(search), tire_search_query)
  end

  def tire_search_query
    return @_tire_search_query if @_tire_search_query

    item = self
    search = self.search

    @_tire_search_query = Tire::Search::Search.new do
      query { filtered {} }

      item.with_context(self) do
        item.facets
        item.paginate
        item.sort
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

        item.filter_match :item_type
        item.filter_match :base_name
        item.filter_match :account
        item.filter_match :thread_id
        item.filter_match :rarity_id
        item.filter_match :archetype if item.typed?
        item.filter_match :corrupted if item.corrupted?

        item.filter_armour_requirements

        [:str, :dex, :int].each do |stat|
          item.filter_between(stat)
        end

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
            item.must_match_string :name, :name, "AND"

            item.must_be_gte :physical_damage
            item.must_be_gte :elemental_damage
            item.must_be_gte :aps
            item.must_be_gte :dps
            item.must_be_gte :physical_dps
            item.must_be_gte :critical_strike_chance
            item.must_be_gte :quality

            item.must_be_between :level

            item.must_have_price

            item.must_have_sockets

            item.must_have_stats
          end
        end
      end
    end.to_hash

    query[:query][:bool].empty? ? find_all : query
  end

  def typed?
    !any_type
  end
end
