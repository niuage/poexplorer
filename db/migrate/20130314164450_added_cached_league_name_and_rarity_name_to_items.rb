class AddedCachedLeagueNameAndRarityNameToItems < ActiveRecord::Migration
  def change
    add_column :items, :league_name, :string, default: nil
    add_column :items, :rarity_name, :string, default: nil
  end
end
