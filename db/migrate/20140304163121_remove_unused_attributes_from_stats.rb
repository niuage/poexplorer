class RemoveUnusedAttributesFromStats < ActiveRecord::Migration
  def up
    remove_column :stats, :exclude
    remove_column :stats, :max_value
  end

  def down
    add_column :stats, :exclude, :boolean
    add_column :stats, :max_value, :integer
  end
end
