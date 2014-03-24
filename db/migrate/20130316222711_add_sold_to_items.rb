class AddSoldToItems < ActiveRecord::Migration
  def change
    add_column :items, :sold, :integer, default: 0
  end
end
