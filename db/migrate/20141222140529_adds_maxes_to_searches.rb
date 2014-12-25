class AddsMaxesToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :max_aps, :float

    change_column :searches, :dps, :float
    change_column :searches, :max_dps, :float

    change_column :searches, :physical_dps, :float
    change_column :searches, :max_physical_dps, :float

    add_column :searches, :max_csc, :float

    add_column :searches, :max_quality, :integer
  end
end
