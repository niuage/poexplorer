class AddLeaguesToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :softcore, :boolean, default: true
    add_column :builds, :hardcore, :boolean, default: true
  end
end
