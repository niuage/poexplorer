class AddSearchFieldsToBuildSearches < ActiveRecord::Migration
  def up
    change_table :build_searches do |t|
      t.string  :keywords
      t.integer :life_type
      t.boolean :softcore, default: true
      t.boolean :hardcore, default: true
      t.string  :skill_gem_ids
      t.string  :unique_ids
      t.string  :klass_ids
      t.string  :keystone_ids
    end
  end

  def down
    remove_column :build_searches, :keywords
    remove_column :build_searches, :life_type
    remove_column :build_searches, :softcore
    remove_column :build_searches, :hardcore
    remove_column :build_searches, :skill_gem_ids
    remove_column :build_searches, :unique_ids
    remove_column :build_searches, :klass_ids
    remove_column :build_searches, :keystone_ids
    remove_column :build_searches, :uid
  end
end
