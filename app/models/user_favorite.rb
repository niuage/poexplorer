class UserFavorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  validates :user_id, uniqueness: { scope: :item_id }
  validates :user, presence: true
  validates :item, presence: true

  after_destroy :update_user_cached_id

  def update_user_cached_id
    user.update_cached_favorite_item_ids
  end
end
