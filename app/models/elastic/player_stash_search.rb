module Elastic
  class PlayerStashSearch < ItemSearch

    def tire_search
      return unless (item = self.search)

      searchable = self
      Tire.search(Indices.item_indices(League)) do
        query do
          boolean do
            searchable.context = self

            must { string "account:#{item.account}" } # important

            must { term :verified, true }

            searchable.must_match :rarity_id
            searchable.must_match :league_id
            searchable.must_match :base_name

            searchable.must_have_sockets
          end
        end

        searchable.with_context(self) do
          searchable.facets
          searchable.paginate
          searchable.sort
        end
      end
    end

  end
end
