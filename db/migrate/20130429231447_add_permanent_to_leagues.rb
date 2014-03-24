class AddPermanentToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :permanent, :boolean, default: false
  end
end
