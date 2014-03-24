class BuildKeystone < ActiveRecord::Base
  belongs_to :build
  belongs_to :keystone
end
