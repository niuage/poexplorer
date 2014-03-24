class CreateSearchStats < ActiveRecord::Migration
  def change
    create_table :search_stats do |t|
      t.string :name
      t.references :search
      t.references :mod

      t.integer :value
      t.integer :max_value

      t.boolean :required, default: false
      t.boolean :excluded, default: false

      t.boolean :gte, default: false
      t.boolean :lte, default: false

      t.boolean :implicit, default: false

      t.timestamps
    end
  end
end
