class Exile < ActiveRecord::Base
  belongs_to :user

  def to_params
    "#{id}-#{name.title}"
  end
end
