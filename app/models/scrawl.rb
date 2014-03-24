class Scrawl < ActiveRecord::Base
  scope :successful, where(successful: true)

  def successful!
    self.update_attribute(:successful, true)
  end
end
