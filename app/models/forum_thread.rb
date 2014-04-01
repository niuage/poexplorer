require 'open-uri'
require 'digest/md5'

class ForumThread < ActiveRecord::Base
  THREAD_ROOT = "http://www.pathofexile.com/forum/view-thread"

  before_save :refresh_items, if: :temp_items_changed
  after_save :update_player

  attr_accessible :last_updated_at, :items, :account, :uid
  attr_accessor :temp_items, :temp_items_changed,
    :new_items_md5, :forum_items

  store :item_store, accessors: :items, coder: JSON

  def thread_changed?
    # edited?: need to reindex because of possible price changes
    # items_md5_changed?: or if some items became unverified
    edited? || items_md5_changed?
  end

  def edited?
    last_updated_at_changed?
  end

  # when there are no more items in the thread
  def clean_up!
    verified_items_uid = verified_items.try(:map) { |i| i[0] }
    Item.where(uid: verified_items_uid).destroy_all if verified_items_uid
    self.items = []
    save
  end

  def find_item(item)
    md5 = ItemBuilder.md5(item)
    items.find { |e| e[0] == md5 } if items
  end

  def <<(item)
    self.temp_items ||= []
    # representation of an item [md5, verified?]
    self.temp_items << [
      ItemBuilder.md5(item),
      ItemBuilder.item_verified?(item)
    ]
    self.temp_items_changed = true
  end

  def update_league
    return if league_id || !any_forum_items?
    self.league_id = League.find_by(name: forum_items[0][1]["league"]).try(:id)
  end

  def any_forum_items?
    forum_items.respond_to?(:each) && forum_items.present?
  end

  def forum_items=(items)
    self.items_md5 = md5(items)
    @forum_items = items
  end

  private

  def update_player
    return if account.blank? || league_id.blank?
    Player
      .by_league(league_id)
      .by_account(account)
      .first_or_create
    puts %Q{
      Player #{account} created in league #{league_id}
    }
  end

  def refresh_items
    self.items = temp_items
  end

  def verified_items
    items.try(:select) { |i| i[1] }
  end

  def md5(elt)
    Digest::MD5.hexdigest(elt.to_s)
  end
end
