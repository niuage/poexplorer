require 'open-uri'
require 'digest/md5'

class Indexer
  POE_URL = "http://www.pathofexile.com"
  FORUM_ROOT = "#{POE_URL}/forum/view-forum"
  THREAD_ROOT = "#{POE_URL}/forum/view-thread"

  #########
  ######### Create a class Thread... or eventually use ForumThread
  #########

  def index_thread(thread_id, scrawl_or_shop = nil)
    forum_thread_html = ForumThreadHtml.new(thread_id)

    # open thread
    thread = forum_thread_html.thread
    return unless thread

    # get the PoExplorer thread
    forum_thread = ForumThread.where(uid: thread_id).first_or_initialize

    # last update date
    first_post_updated_at = forum_thread_html.thread_date

    # get items
    forum_thread.forum_items = forum_thread_html.items

    # exit if no items
    return forum_thread.clean_up! unless forum_thread.any_forum_items?

    forum_thread.update_league

    # update the thread last_updated_at date
    forum_thread.last_updated_at = first_post_updated_at

    # exit if thread did not change
    return forum_thread.save unless forum_thread.thread_changed?

    thread_edited = forum_thread.edited?

    # no need to get the prices if the thread hasnt been updated at all
    prices = thread_edited ? forum_thread_html.prices : []

    md5_to_update = []
    items_to_index = []

    # for every actual items
    forum_thread.forum_items.reverse_each do |index_and_item|
      item = index_and_item[1]
      forum_item = forum_thread.find_item(item)

      if ItemBuilder.item_verified?(item)
        # add the item md5 to the item
        # old md5 if already indexed, or new md5
        md5_to_update << ((forum_item && forum_item[0]).presence || ItemBuilder.md5(item))

        # if item is not already indexed or has a price
        if (!forum_item || !forum_item[1]) || (thread_edited && prices[index_and_item[0]])
          items_to_index << index_and_item
        end
      else
        # destroy the item if it's not verified anymore
        Item.find_by(
          uid: ItemBuilder.md5(item),
          thread_id: forum_thread.uid
        ).try(:destroy)
      end

      # add the item to the temporary-items list
      # which will replace the current one on save
      forum_thread << item
    end

    # update the meta data of all the verified items
    items_to_update = Item.where(uid: md5_to_update, thread_id: forum_thread.uid)
    items_to_update.update_all(
      thread_updated_at: first_post_updated_at,
      indexed_at: Time.zone.now
    )
    TireIndex.store(forum_thread.league_id, items_to_update)

    # update stuff like the username
    forum_thread.account = forum_thread_html.account

    # useless?
    last_updated_at(scrawl_or_shop, first_post_updated_at) if scrawl_or_shop

    # for every item to index

    ActiveRecord::Base.transaction do
      items_to_index.each do |item|
        next if item.length < 2

        builder = ItemBuilder.new(item[1], prices[item[0]], forum_thread)
        builder.update_prices = thread_edited
        if builder.save
          update_stats(scrawl_or_shop, builder.item) if scrawl_or_shop
        end
      end
    end

    forum_thread.save

    closing_thread(scrawl_or_shop) if scrawl_or_shop
  end

  def last_updated_at(scrawl_or_shop, updated_at); end

  def closing_thread(scrawl_or_shop); end
end
