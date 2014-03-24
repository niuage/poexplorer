class AddSupportToSkillGems < ActiveRecord::Migration
  def change
    add_column :skill_gems, :support, :boolean, default: false
  end
end
