class AddAlternativesToBanditChoices < ActiveRecord::Migration
  def change
    add_column :bandit_choices, :alternatives, :text
  end
end
