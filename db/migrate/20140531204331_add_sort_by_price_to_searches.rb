class AddSortByPriceToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :sort_by_price, :boolean, default: false
  end
end
