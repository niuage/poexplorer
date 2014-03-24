class AddContactInfoToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :contact_info, :string
  end
end
