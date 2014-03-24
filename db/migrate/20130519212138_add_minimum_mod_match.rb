class AddMinimumModMatch < ActiveRecord::Migration
  def change
    add_column :searches, :minimum_mod_match, :integer, default: 0
  end
end
