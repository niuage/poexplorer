class AddUserUidToBuildSearches < ActiveRecord::Migration
  def change
    add_column :build_searches, :user_uid, :integer
  end
end
