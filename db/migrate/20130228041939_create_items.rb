class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references  :league
      t.references  :rarity

      t.string      :name, null: false
      t.string      :base_name
      t.string      :account

      t.text        :socket_store

      t.integer     :quality

      t.integer     :block_chance
      t.integer     :armour
      t.integer     :evasion
      t.integer     :energy_shield

      t.integer     :physical_damage
      t.integer     :dps
      t.float       :csc
      t.float       :aps

      t.integer     :level
      t.string      :requirements

      t.string      :type

      t.string      :price
      t.string      :thread_id
      t.boolean     :verified
      t.boolean     :identified
      t.datetime    :indexed_at


      t.string      :icon
      t.text        :raw_icon

      t.string      :uid
      t.timestamps
    end
  end
end
