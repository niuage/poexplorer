class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references    :league
      t.boolean       :online, default: false
      t.string        :account
      t.string        :character
      t.datetime      :marked_online_at
      t.datetime      :last_online
      t.timestamps
    end

    add_index :players, :account
    add_index :players, [:character, :league_id]
    add_index :players, [:account, :league_id]
  end
end
