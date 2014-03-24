class ShopIndexer < Indexer

  MIN_DELAY = 2.hours.ago

  attr_accessor :logging, :force_indexing

  def initialize force_indexing = false, options = {}
    @logging = options[:logging]
    @force_indexing = force_indexing
  end

  def process_all
    Shop.processing.valid.find_each do |shop|
      puts "processing shop" if logging
      process(shop)
    end
  end

  def index_all
    shops = Shop.visible
    shops = shops.scrawled_before(MIN_DELAY) if !force_indexing
    shops.find_each do |shop|
      index(shop)
    end
  end

  def process(shop)
    thread = open_thread(shop.thread_id)
    shop.title = thread_title(thread)
    shop.league = thread_league(thread)
    shop.username = username(thread)

    shop.processing = false

    if shop.save
      index(shop)
      puts "shop indexed" if logging
    else
      shop.update_attribute(:is_invalid, true)
    end
  rescue => e
    puts e.message
    return false
  end

  def index(shop)
    thread = open_thread(shop.thread_id)

    shop.reset_counts
    # in a perfect world,
    # I should also reset all the linked items...
    index_thread(thread, shop)

    shop.scrawled
    shop.save
  rescue => e
    puts e.message
    return false
  end

  def index_thread_from_id(thread_id)
    Item.where(thread_id: thread_id).destroy_all
    index_thread(thread_id)
  end

  def update_stats(shop, item)
    return unless item
    item.shop = shop
    saved = item.save
    puts "item saved (#{saved}) in shop #{shop.id}"  if logging

    if item.verified?
      case
      when item.weapon?; shop.increment(:weapon_count)
      when item.armour?; shop.increment(:armour_count)
      when item.misc?; shop.increment(:misc_count)
      end
    end
  end

  def last_updated_at(shop, date)
    shop.last_updated_at = date
  end

  private

  def thread_league(thread)
    forum = thread.css(".breadcrumb a").last.content()
    matches = forum.match /(default|hardcore).*(shops|selling)/i
    return unless matches.try(:length) == 3
    League.find_by(name: matches[1].downcase)
  end

  def thread_title(thread)
    thread.css(".layoutBoxTitle").first.content()
  end

  def username(thread)
    thread.css(".profile-link").first.try :content
  end

end
