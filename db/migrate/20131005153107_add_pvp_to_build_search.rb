class AddPvpToBuildSearch < ActiveRecord::Migration
  def change
    add_column :build_searches, :pvp, :boolean, default: false
  end
end
