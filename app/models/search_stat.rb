class SearchStat < ActiveRecord::Base
  attr_accessible :mod_id, :value, :max_value, :required, :excluded,
    :gte, :lte, :name, :mod, :implicit

  belongs_to :search
  belongs_to :mod

  validates :mod, presence: true

  include StatExtensions::Stat
end

