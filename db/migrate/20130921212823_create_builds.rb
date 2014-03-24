class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.references  :user
      t.string      :title
      t.string      :summary
      t.text        :description
      t.string      :video_url
      t.integer     :life_type
      t.integer     :playstyle
      t.integer     :role
      t.boolean     :pvp
      t.string      :version
      t.boolean     :indexed
      t.boolean     :certified
      t.timestamps
    end
  end
end
