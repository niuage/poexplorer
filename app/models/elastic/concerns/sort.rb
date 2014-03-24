module Elastic::Concerns::Sort
  extend ActiveSupport::Concern

  included do
    attr_accessor :sorter
  end

  def sort(options = {})
    sorter = ItemSorting.new(self)

    context.sort do
      sorter.with_context(self) do
        sorter.sort_by_mod_id
        sorter.sort_by_attributes
        sorter.sort_by_score if options[:score]
        sorter.default_sort
      end
    end
  end
end
