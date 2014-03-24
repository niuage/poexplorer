class ModItemType < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :mod
end
