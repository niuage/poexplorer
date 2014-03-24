class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.references      :user
      t.references      :league

      t.boolean         :notifications
      t.boolean         :processing
      t.boolean         :is_invalid, default: false

      # thread related
      t.integer         :thread_id
      t.string          :title
      t.string          :username
      t.datetime        :last_updated_at

      # stats
      t.integer         :weapon_count
      t.integer         :armour_count
      t.integer         :misc_count

      t.datetime        :indexed_at
      t.timestamps
    end
  end
end
