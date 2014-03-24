class Unique < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  alias_attribute :base_name, :base_item
end
