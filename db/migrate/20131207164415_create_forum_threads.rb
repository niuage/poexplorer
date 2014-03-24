class CreateForumThreads < ActiveRecord::Migration
  def change
    create_table :forum_threads do |t|
      t.string      :account
      t.string      :items_md5
      t.text        :item_store
      t.integer     :uid
      t.references  :league
      t.datetime    :last_updated_at
      t.timestamps
    end
  end
end
