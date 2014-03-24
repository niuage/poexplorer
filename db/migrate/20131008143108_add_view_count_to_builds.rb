class AddViewCountToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :views, :integer, default: 0
  end
end
