class ChangeSkillTreeUrlTypeToText < ActiveRecord::Migration
  def up
    change_column :skill_trees, :url, :text
  end

  def down
    change_column :skill_trees, :url, :string
  end
end
