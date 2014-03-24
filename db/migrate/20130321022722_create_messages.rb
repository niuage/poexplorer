class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string        :title
      t.text          :body
      t.references    :sender
      t.references    :recipient
      t.timestamps
    end
  end
end
