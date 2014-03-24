class CreateBuildClasses < ActiveRecord::Migration
  def change
    create_table :build_classes do |t|
      t.references :build
      t.references :klass
      t.timestamps
    end
  end
end
