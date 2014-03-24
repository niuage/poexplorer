class CreateSkillTrees < ActiveRecord::Migration
  def change
    create_table :skill_trees do |t|
      t.references  :build
      t.string      :url
      t.text        :description
      t.integer     :level
      t.timestamps
    end
  end
end
