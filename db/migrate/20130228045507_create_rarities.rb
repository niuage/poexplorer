class CreateRarities < ActiveRecord::Migration
  def change
    create_table :rarities do |t|
      t.string      :name, null: false
      t.integer     :frame_type
      t.timestamps
    end
  end
end
