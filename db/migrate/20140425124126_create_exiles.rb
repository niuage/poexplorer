class CreateExiles < ActiveRecord::Migration
  def change
    create_table :exiles do |t|
      t.string      :name
      t.text        :tagline
      t.text        :description
      t.references  :user
      t.string      :video_uid
      t.string      :album_uid
      t.timestamps
    end
  end
end
