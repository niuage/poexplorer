class CreateScrawls < ActiveRecord::Migration
  def change
    create_table :scrawls do |t|
      t.integer     :thread_count
      t.integer     :item_count
      t.boolean     :successful
      t.timestamps
    end
  end
end
