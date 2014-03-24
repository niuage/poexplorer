class AddElementalDamageToItems < ActiveRecord::Migration
  def change
    add_column :items, :elemental_damage, :integer, default: nil
  end
end
