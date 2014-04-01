module UserExtensions
  module ShoppingCart
    extend ActiveSupport::Concern

    included do
      serialize :cached_favorite_item_ids

      has_many :user_favorites, dependent: :destroy
      has_many :favorite_items, -> { order("items.identified DESC") }, through: :user_favorites, source: :item
    end

    def cached_favorite_item_ids
      self[:cached_favorite_item_ids] ||= []
      self[:cached_favorite_item_ids]
    end

    def user_favorites_count
      cached_favorite_item_ids.length
    end

    def update_cached_favorite_item_ids
      update_attribute(:cached_favorite_item_ids, user_favorites.pluck(:item_id))
    end
  end
end
