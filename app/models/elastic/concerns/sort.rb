module Elastic::Concerns::Sort
  extend ActiveSupport::Concern

  included do
    attr_writer :sorter
  end

  def sorter
    @_sorter ||= ItemSorting.new(self)
  end

  def sort(options = {})
    sorter = self.sorter

    context.sort do
      sorter.with_context(self) do
        sorter.sort_by_mod_id
        sorter.sort_by_attributes
        sorter.sort_by_score if options[:score]
        sorter.default_sort
      end
    end
  end

  def sort_query(options = {})
    item = self

    sort_query = Tire::Search::Search.new do
      item.with_context(self) do
        item.sort(options)
      end
    end

    sort_query.to_hash.tap do |query|
      if sorter.sort_by_price?
        query[:sort].unshift(sort_by_price_query)
      end
    end
  end

  def sort_by_price_query
    {
      "_script" => {
        script: Currency.sorting_script,
        type: 'number',
        params: {
          exa_price: 30,
          chaos_price: 1,
          alch_price: 0.4,
          gcp_price: 1.5
        },
        order: 'asc'
      }
    }
  end
end
