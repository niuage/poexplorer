module Elastic::Concerns::Sort
  extend ActiveSupport::Concern

  def sorter
    @_sorter ||= ItemSorting.new(self)
  end

  def sort(options = {})
    sorter = self.sorter

    context.sort do
      sorter.with_context(self) do
        sorter.sort_by_score if sorter.sort_by_price?
        sorter.sort_by_mod_id
        sorter.sort_by_attributes

        if !sorter.sort_by_price? && options[:score]
          sorter.sort_by_score
        end

        sorter.default_sort
      end
    end
  end
end
