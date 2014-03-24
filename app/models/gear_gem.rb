class GearGem < ActiveRecord::Base
  belongs_to :gear, counter_cache: true
  belongs_to :skill_gem
end
