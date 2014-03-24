class AddPublishedAtToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :published_at, :datetime, default: nil
  end
end
