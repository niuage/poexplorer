class AddIndexesOnLeagueAndRarity < ActiveRecord::Migration
  def change
    add_index :rarities, :name
    add_index :leagues, :name
  end
end
