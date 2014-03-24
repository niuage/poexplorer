class CreateBuildSearches < ActiveRecord::Migration
  def change
    create_table :build_searches do |t|
      t.string      :uid, default: nil
      t.references  :user
      t.references  :build
      t.string      :order
      t.timestamps
    end

    add_index :build_searches, :uid
  end
end
