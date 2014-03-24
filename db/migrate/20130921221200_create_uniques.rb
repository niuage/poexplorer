class CreateUniques < ActiveRecord::Migration
  def change
    create_table :uniques do |t|
      t.string      :name
      t.string      :base_item
      t.timestamps
    end
  end
end
