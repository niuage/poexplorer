class BuildUnique < ActiveRecord::Base
  belongs_to :unique
  belongs_to :build
end
