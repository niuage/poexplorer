class CreateBuildUniques < ActiveRecord::Migration
  def change
    create_table :build_uniques do |t|
      t.references :build
      t.references :unique
    end
  end
end
