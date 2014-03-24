module Extensions::Uid
  extend ActiveSupport::Concern

  included do
    validates :uid, presence: true, uniqueness: true, length: { is: 10 }
    before_validation :generate_uid, on: :create
  end

  def to_param
    uid
  end

  def generate_uid
    self.uid = [*('a'..'z'),*('0'..'9')].shuffle[0, 10].join
  end
end
