class CreateExileSearches < ActiveRecord::Migration
  def change
    create_table :exile_searches do |t|
      t.string      :uid
      t.string      :keywords
      t.string      :unique_ids
      t.string      :klass_ids
      t.references  :user     # search owner
      t.integer     :user_uid # exile creator id
      t.string      :order
      t.timestamps
    end
  end
end
