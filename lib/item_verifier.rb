require 'digest/md5'

class ItemVerifier
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def verify_item
    begin
      item.verified = item_verified?
      item.indexed_at = Time.zone.now
      item.save
    rescue => e
      return false
    end
  end

  private

  def item_verified?
    forum_thread = ForumThreadHtml.new(item.thread_id)

    return false unless forum_thread.items

    forum_thread.items.each do |poe_item|
      item_attrs = poe_item[1]

      md5 = ItemBuilder.md5(item_attrs)

      if item.uid == md5
        return ItemBuilder.item_verified?(item_attrs)
      end
    end

    false
  end
end
