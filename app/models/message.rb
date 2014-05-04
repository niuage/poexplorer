class Message < ActiveRecord::Base
  attr_accessible :title, :body, :contact_info

  belongs_to :recipient, class_name: "User", foreign_key: :recipient_id
  belongs_to :sender, class_name: "User", foreign_key: :sender_id

  validates :body, presence: true
  validates :contact_info,
    length: { maximum: 128 },
    presence: { message: "Please provide a way for me to answer you (email, reddit name etc)." }
end
