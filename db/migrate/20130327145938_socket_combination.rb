class SocketCombination < ActiveRecord::Migration
  def change
    add_column :items, :socket_combination, :string
  end
end
