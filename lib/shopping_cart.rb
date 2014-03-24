class ShoppingCart

  attr_accessor :user, :item, :dirty, :errors

  def initialize user
    @user = user
    @dirty = false
    @errors = []
  end

  def add_item(item)
    return if ids.include?(item.id)

    favorite = UserFavorite.create do |f|
      f.user_id = user.id
      f.item_id = item.id
    end

    if favorite
      user.cached_favorite_item_ids << favorite.item_id
      self.dirty = true
    end
  end

  def remove_item(item)
    return if !ids.include?(item.id)

    UserFavorite.where(user_id: user.id, item_id: item.id).destroy_all
  end

  def item_in_cart?(item)
    true if ids && ids.include?(item.id)
  end

  def self.item_in_user_cart?(user, item)
    true if user.cached_favorite_item_ids &&
      user.cached_favorite_item_ids.include?(item.id)
  end

  def self.item_count(user)
    return 0 unless user
    user.user_favorites_count
  end

  def save
    return unless dirty?
    user.save
  end

  def valid?
    errors.empty?
  end

  def ids
    @ids ||= user.cached_favorite_item_ids
  end

  def dirty?
    !!dirty
  end

end
