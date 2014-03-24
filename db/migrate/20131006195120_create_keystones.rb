class CreateKeystones < ActiveRecord::Migration
  def change
    create_table :keystones do |t|
      t.string      :name
      t.text        :description
      t.string      :icon
      t.integer     :uid
    end
  end
end
