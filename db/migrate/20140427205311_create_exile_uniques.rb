class CreateExileUniques < ActiveRecord::Migration
  def change
    create_table :exile_uniques do |t|
      t.references :unique
      t.references :exile
      t.timestamps
    end
  end
end
