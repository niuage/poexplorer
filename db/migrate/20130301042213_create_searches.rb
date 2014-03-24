class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.references  :user
      t.references  :item, polymorphic: true
      t.references :league

      t.integer :str
      t.integer :max_str
      t.integer :int
      t.integer :max_int
      t.integer :dex
      t.integer :max_dex

      t.string  :uid, default: nil

      t.string :account
      t.string :full_name
      t.string :name
      t.string :base_name
      t.string :currency
      t.string :socket_combination
      t.string :thread_id
      t.string :quality

      t.integer :dps
      t.integer :max_dps
      t.integer :physical_dps
      t.integer :max_physical_dps

      t.float :aps
      t.float :critical_strike_chance

      t.float :price_value
      t.float :max_price_value

      t.integer :physical_damage
      t.integer :max_physical_damage
      t.integer :elemental_damage
      t.integer :max_elemental_damage

      t.integer :block_chance
      t.integer :max_block_chance
      t.integer :armour
      t.integer :max_armour
      t.integer :evasion
      t.integer :max_evasion
      t.integer :energy_shield
      t.integer :max_energy_shield

      t.integer :rarity_id

      t.integer :socket_count
      t.integer :max_socket_count
      t.integer :linked_socket_count
      t.integer :max_linked_socket_count

      t.integer :level
      t.integer :max_level

      t.boolean :has_price, default: false
      t.boolean :same_item_type
      t.boolean :corrupted
      t.boolean :online, default: false

      t.string :order, default: nil

      t.string :type

      t.timestamps
    end

    add_index :searches, :uid
  end
end
