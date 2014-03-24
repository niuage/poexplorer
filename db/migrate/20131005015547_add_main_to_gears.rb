class AddMainToGears < ActiveRecord::Migration
  def change
    add_column :gears, :main, :boolean, default: false
  end
end
