class CreateFastSearches < ActiveRecord::Migration
  def change
    create_table :fast_searches do |t|
      t.string :uid
      t.text :query
      t.references :user
      t.references :league
      t.timestamps null: false
    end
  end
end
