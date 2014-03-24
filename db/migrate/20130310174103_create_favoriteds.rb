class CreateFavoriteds < ActiveRecord::Migration
  def change
    create_table :favoriteds do |t|
      t.references :search
      t.references :user
      t.timestamps
    end
  end
end
