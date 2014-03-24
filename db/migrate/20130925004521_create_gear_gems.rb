class CreateGearGems < ActiveRecord::Migration
  def change
    create_table :gear_gems do |t|
      t.references :gear
      t.references :skill_gem
    end
  end
end
