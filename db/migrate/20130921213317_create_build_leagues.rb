class CreateBuildLeagues < ActiveRecord::Migration
  def change
    create_table :build_leagues do |t|
      t.references :build
      t.references :league
      t.timestamps
    end
  end
end
