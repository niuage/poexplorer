class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      t.string      :title
      t.string      :body
      t.integer     :priority
      t.timestamps
    end
  end
end
