class SkillTree < ActiveRecord::Base
  belongs_to :build

  attr_accessible :url, :level, :description

  validates :url, format: { with: /pathofexile\.com\/passive-skill-tree/, message: "This skill tree url is not valid." }, allow_blank: false
end
