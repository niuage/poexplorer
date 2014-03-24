class CreateBanditChoices < ActiveRecord::Migration
  def change
    create_table :bandit_choices do |t|
      t.references  :build
      t.integer     :normal_choice
      t.integer     :cruel_choice
      t.integer     :merciless_choice
    end
  end
end
