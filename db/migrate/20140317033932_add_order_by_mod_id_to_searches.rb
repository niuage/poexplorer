class AddOrderByModIdToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :order_by_mod_id, :integer, default: nil
  end
end
