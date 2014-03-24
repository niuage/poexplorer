class AddGroupToModItemType < ActiveRecord::Migration
  def change
    add_column :mod_item_types, :mod_group, :string
  end
end
