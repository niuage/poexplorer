class CreateModItemTypes < ActiveRecord::Migration
  def change
    create_table :mod_item_types do |t|
      t.references :mod
      t.references :item_type
    end

    add_index :mod_item_types, :item_type_id
    add_index :mod_item_types, :mod_id
  end
end
