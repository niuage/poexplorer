class AddsEdpsToItemsAndSearches < ActiveRecord::Migration
  def change
    add_column :searches, :edps, :float
    add_column :searches, :max_edps, :float
  end
end
