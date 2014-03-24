class AddIndexOnModsOnName < ActiveRecord::Migration
  def change
    add_index :mods, :name
  end
end
