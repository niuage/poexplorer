require 'open-uri'
require 'digest/md5'

class ThreadIndexer

  attr_accessor :thread_id,
    :md5_to_update,
    :items_to_index

  def initialize(thread_id)
    self.thread_id = thread_id
    self.md5_to_update = []
    self.items_to_index = []
  end

  def index
    return unless thread_html.thread

    # get thread items (also sets the items md5)
    forum_thread.forum_items = thread_html.items

    # exit if no items
    return unless forum_thread.any_forum_items?

    forum_thread.update_league

    # update the thread last_updated_at date
    forum_thread.last_updated_at = thread_html.thread_date

    # exit if thread did not change
    if !forum_thread.thread_changed?
      return puts("forum thread didnt change (#{thread_id})") && forum_thread.save
    end

    # find items to update
    # find items to index
    # update the forum thread item list
    update_forum_thread_items

    # update the meta data of all the verified items
    # in mysql and elasticsearch
    update_verified_items

    forum_thread.account = thread_html.account

    # index missing items
    # or update priced items
    index_missing_or_priced_items

    # Save the thread
    # Sets the new item list
    forum_thread.save
  rescue OpenURI::HTTPError => e
    Bugsnag.notify(e, { thread_id: thread_id })
  rescue StandardError => e
    Bugsnag.notify(e, { thread_id: thread_id })
    raise e
  end

  private

  def update_forum_thread_items
    # for every actual items
    forum_thread.forum_items.reverse_each do |index_and_item|
      forum_item = index_and_item[1]
      cached_item = forum_thread.find_item(forum_item)

      if ItemBuilder.item_verified?(forum_item)
        # add the item md5 to the item
        # old md5 if already indexed, or new md5
        cached_md5 = cached_item.try :[], 0
        md5_to_update << (cached_md5.presence || ItemBuilder.md5(forum_item))

        # if item is not already indexed or has a price
        if (!cached_item || prices[index_and_item[0]])
          items_to_index << index_and_item
        end

        # add the item to the temporary-items list
        # which will replace the current one on save
        forum_thread << forum_item
      end
    end

    forum_thread.temp_items_changed = forum_thread.forum_items.any?
  end

  def update_verified_items
    items_to_update = Item.where(uid: md5_to_update, thread_id: forum_thread.uid)
    items_to_update.update_all(
      thread_updated_at: forum_thread.last_updated_at,
      indexed_at: Time.zone.now
    )
    TireIndex.store(forum_thread.league_id, items_to_update)
  end

  def index_missing_or_priced_items
    ActiveRecord::Base.transaction do
      items_to_index.each do |item|
        next if item.length < 2

        builder = ItemBuilder.new(item[1], prices[item[0]], forum_thread)
        builder.update_prices = forum_thread.edited?
        builder.save
      end
    end
  end

  def prices
    # no need to get the prices if the thread
    # hasnt been updated at all
    @_prices ||= forum_thread.edited? ? thread_html.prices : []
  end

  def forum_thread
    @_forum_thead ||= ForumThread
      .where(uid: thread_id)
      .first_or_initialize
  end

  def thread_html
    @_thread_html ||= ForumThreadHtml.new(thread_id)
  end
end
