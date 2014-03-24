class AddLeagueToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.references :league
      t.string     :league_name, default: nil
    end
  end

  def down
    remove_column :users, :league_id
    remove_column :users, :league_name
  end
end
