class CreateBuildKeystones < ActiveRecord::Migration
  def change
    create_table :build_keystones do |t|
      t.references :build
      t.references :keystone
    end
  end
end
