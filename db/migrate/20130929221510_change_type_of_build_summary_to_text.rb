class ChangeTypeOfBuildSummaryToText < ActiveRecord::Migration
  def up
    change_column :builds, :summary, :text
  end

  def down
    change_column :builds, :summary, :string
  end
end
