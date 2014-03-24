class AddShopIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :shop_id, :integer
    add_index :items, :shop_id
  end
end
