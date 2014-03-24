class CreateSkillGems < ActiveRecord::Migration
  def change
    create_table :skill_gems do |t|
      t.string      :name
      t.string      :description
      t.string      :attr
      t.timestamps
    end
  end
end
