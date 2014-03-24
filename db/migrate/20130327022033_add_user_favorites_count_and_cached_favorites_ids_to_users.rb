class AddUserFavoritesCountAndCachedFavoritesIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cached_favorite_item_ids, :text
  end
end
