class AddIndexToItemsOnThreadIdAndMd5 < ActiveRecord::Migration
  def change
    add_index :items, [:uid, :thread_id]
  end
end
