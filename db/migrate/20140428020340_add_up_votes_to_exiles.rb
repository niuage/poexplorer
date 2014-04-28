class AddUpVotesToExiles < ActiveRecord::Migration
  def change
    add_column :exiles, :up_votes, :integer, null: false, default: 0
    add_column :exiles, :down_votes, :integer, null: false, default: 0
  end
end
