class BuildClass < ActiveRecord::Base
  belongs_to :build
  belongs_to :klass
end
