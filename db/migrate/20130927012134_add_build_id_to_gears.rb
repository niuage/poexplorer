class AddBuildIdToGears < ActiveRecord::Migration
  def change
    add_column :gears, :build_id, :integer
  end
end
