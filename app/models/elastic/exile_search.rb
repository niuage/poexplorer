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
                must { string search.keywords } if search.keywords.present?
              end
            end
          }
        }

        sort do

          by :updated_at, 'desc'
        end

        facet "class" do
          terms :klass_name, size: 5
        end

        facet "unique" do
          terms :unique_ids, size: 5
        end

        sort do
          if search.order.present?
            case search.order
            when "popular"
              by "up_votes", order: "desc"
            end
          end
          by "created_at", order: "desc"
        end

        exile.paginate(self)

      end.to_hash

      if @_tire_search_query[:query][:filtered][:query][:bool].empty?
        @_tire_search_query[:query][:filtered].update(find_all)
      end

      @_tire_search_query
    end
  end
end
