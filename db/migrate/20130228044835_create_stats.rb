class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string     :name
      t.references :item
      t.references :mod
      t.integer    :value
      t.integer    :max_value
      t.timestamps
    end
  end
end
