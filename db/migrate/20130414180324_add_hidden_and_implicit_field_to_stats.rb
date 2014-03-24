class AddHiddenAndImplicitFieldToStats < ActiveRecord::Migration
  def change
    change_table :stats do |t|
      t.boolean :hidden, default: false
      t.boolean :implicit, default: false
    end

  end
end
