class Account < ActiveRecord::Base
  validates :name, presence: true
  validates :user, presence: true

  belongs_to :user

  has_many :players, foreign_key: "account", primary_key: "name"

  def to_param
    name
  end
end
