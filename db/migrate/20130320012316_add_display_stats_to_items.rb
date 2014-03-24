class AddDisplayStatsToItems < ActiveRecord::Migration
  def change
    add_column :items, :display_stats, :string
  end
end
