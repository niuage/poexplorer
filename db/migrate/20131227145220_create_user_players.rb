class CreateUserPlayers < ActiveRecord::Migration
  def change
    create_table :user_players do |t|
      t.references :user
      t.references :player
      t.timestamps
    end
  end
end
