class CreateGears < ActiveRecord::Migration
  def change
    create_table :gears do |t|
      t.string      :name
      t.string      :description
      t.integer     :gear_gems_count
      t.timestamps
    end
  end
end
