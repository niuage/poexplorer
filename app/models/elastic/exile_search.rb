module Elastic
  class ExileSearch < BaseSearch

    def tire_search
      Tire.search(Exile.tire.index_name, tire_search_query)
    end

    def tire_search_query
      return @_tire_search_query if @_tire_search_query

      exile = self
      search = self.search

      @_tire_search_query = Tire::Search::Search.new do
        query {
          filtered {
            filter :term, user_id: search.user_uid if search.user_uid.present?
            filter :terms, klass_id: search.klass_ids, execution: 'or' if search.klass_ids.present?
            filter :terms, unique_ids: search.unique_ids, execution: 'or' if search.unique_ids.present?

            query do
              boolean do
              end
            end
          }
        }

        facet "klasses" do
          terms :klass_id, size: 5
        end

        facet "uniques" do
          terms :unique_ids, size: 5
        end
      end.to_hash

      @_tire_search_query[:query][:filtered].merge!(find_all)

      @_tire_search_query
    end
  end
end
