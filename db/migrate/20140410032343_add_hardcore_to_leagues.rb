class AddHardcoreToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :hardcore, :boolean, default: false
  end
end
