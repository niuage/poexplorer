class AddSizeToItems < ActiveRecord::Migration
  def change
    add_column :items, :size, :string
  end
end
