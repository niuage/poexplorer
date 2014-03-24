class AddThreadLastUpdatedAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :thread_updated_at, :date
  end
end
