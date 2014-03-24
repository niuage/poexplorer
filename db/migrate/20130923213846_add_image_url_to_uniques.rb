class AddImageUrlToUniques < ActiveRecord::Migration
  def change
    add_column :uniques, :image_url, :string
  end
end
