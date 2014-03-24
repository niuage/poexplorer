require 'open-uri'
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
    thread = Nokogiri::HTML(open(thread_url))

    items = find_poe_items(thread)
    return false unless items

    items.each do |poe_item|
      item_attrs = poe_item[1]

      md5 = ItemBuilder.md5(item_attrs)
      verified = ItemBuilder.item_verified?(item_attrs)

      if item.uid == md5
        # [PERF] THIS COULD BE IMPROVED BY STOPPING AS SOON
        # AS THE PRICE IS FOUND
        item.price = PriceParser.new(thread)[poe_item[0]] if verified
        return verified
      end
    end

    false
  end

  def find_poe_items(thread)
    content = thread.css("script").last.content
    return unless content && content.include?("DeferredItemRenderer")
    matches = content.match(/new R\((.*)\)\)\.run\(\)/)
    return unless matches.length > 1
    return JSON.parse(matches[1])
  end

  def thread_url
    Indexer.thread_url(item.thread_id)
  end
end
