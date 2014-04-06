class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references  :user
      t.string      :name
      t.timestamps
    end
  end
end
