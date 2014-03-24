module Elastic
  class CartSearch < ItemSearch

    def tire_search(ids)
      return unless ids
      searchable = self

      Tire.search(Indices.item_indices(League), tire_search_hash(ids))
    end

    def tire_search_hash(ids)
      return @_tire_search_query if @_tire_search_query

      item = self

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
        query[:query][:filtered].update(filter_query(ids))
      end
    end

    def filter_query(ids)
      item = self

      Tire::Search::Search.new do
        item.with_context(self) do
          filter :terms, id: ids
          item.filter_match :rarity_id
          item.filter_match :base_name
        end
      end.to_hash
    end

    def boolean_query
      item = self

      query = Tire::Search::Search.new do
        query do
          boolean do
            item.with_context(self) do
              item.must_have_sockets
            end
          end
        end
      end.to_hash

      query[:query][:bool].empty? ? find_all : query
    end

  end
end
