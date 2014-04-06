class AddIndexToSearchStats < ActiveRecord::Migration
  def change
    add_index :search_stats, :search_id
  end
end
