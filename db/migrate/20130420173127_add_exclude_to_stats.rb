class AddExcludeToStats < ActiveRecord::Migration
  def change
    add_column :stats, :exclude, :boolean, default: false
  end
end
