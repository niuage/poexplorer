class Elastic::ItemSearch < Elastic::BaseItemSearch
  include Elastic::Concerns::Item

  attr_accessor :any_type

  def tire_search
    Tire.search(Indices.item_indices(search), tire_search_query)
  end

  def fast_search
    Tire.search(Indices.item_indices(search), fast_search_query)
  end

  def tire_search_query
    item = self
    search = self.search

    filtered_query.merge(meta_query)
  end

  def filtered_query
    @_filtered_query ||= {
      query: {
        filtered: {}.update(boolean_query).update(filter_query)
      }
    }
  end

  def meta_query
    item = self

    Tire::Search::Search.new do
      item.with_context(self) do
        # item.facets
        item.paginate
        item.sort
      end
    end
  end

  def fast_search_query
    return find_all if search.query.blank?

    self.search = TireSearch.new(search.query).to_search

    tire_search_query
  end

  def filter_query
    item = self

    Tire::Search::Search.new do
      item.with_context(self) do
        filter :term, verified: true

        if item.generic_type?
          filter :terms, item_type: item.generic_type, execution: "or"
        else
          item.filter_match :item_type
        end
        item.filter_match :base_name
        item.filter_match :account
        item.filter_match :thread_id
        item.filter_match :rarity_id
        item.filter_match :archetype if item.typed?

        item.filter_between(:chaos_value)

        # filter :not, { term: { chaos_value: 0 } } if item.search.has_price?

        filter :term, corrupted: item.corrupted == 1 if item.corrupted != 0

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
            if item.ngram_full_name.present?
              must { match :ngram_full_name, item.ngram_full_name, operator: "AND" }
            end

            item.must_match_string :name, :name, "AND"

            item.must_be_between :damage
            item.must_be_between :physical_damage
            item.must_be_between :elemental_damage
            item.must_be_between :aps
            item.must_be_between :dps
            item.must_be_between :physical_dps
            item.must_be_between :edps
            item.must_be_between :csc
            item.must_be_between :quality

            item.must_be_between :level

            item.must_have_sockets

            # item.must_have_stats
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
