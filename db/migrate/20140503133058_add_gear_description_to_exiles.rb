class AddGearDescriptionToExiles < ActiveRecord::Migration
  def change
    add_column :exiles, :gear_description, :text
  end
end
