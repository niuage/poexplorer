class CreateKlasses < ActiveRecord::Migration
  def change
    create_table :klasses do |t|
      t.string      :name
      t.string      :description
      t.timestamps
    end
  end
end
