class AddStatIndexOnItemId < ActiveRecord::Migration
  def change
    add_index :stats, :item_id
  end
end
