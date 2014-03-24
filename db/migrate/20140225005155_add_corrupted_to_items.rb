class AddCorruptedToItems < ActiveRecord::Migration
  def change
    add_column :items, :corrupted, :boolean, default: false
  end
end
