class CreateUserFavorites < ActiveRecord::Migration
  def change
    create_table :user_favorites do |t|
      t.references :user
      t.references :item
      t.timestamps
    end
  end
end
