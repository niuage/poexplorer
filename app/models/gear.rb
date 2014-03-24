class Gear < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :build

  has_many :gear_gems, dependent: :destroy
  has_many :skill_gems, through: :gear_gems, order: "(support = true) ASC"

  attr_accessible :name, :description, :skill_gem_ids, :main

  accepts_nested_attributes_for :skill_gems

  validates_with GearValidator

  scope :main, -> { where(main: true) }
end
