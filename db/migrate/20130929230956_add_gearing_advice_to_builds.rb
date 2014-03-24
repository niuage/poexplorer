class AddGearingAdviceToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :gearing_advice, :text
    add_column :builds, :conclusion, :text
  end
end
