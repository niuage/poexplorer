class PriceParser

  ORBS = %w{exa alch chaos gcp chrom alt jew chance chisel carto fus scour blessed regret regal divine}

  attr_accessor :prices, :post

  def initialize(thread)
    @post = first_post(thread)
    @prices = []
    parse
  end

  def parse
    return unless post

    # set global offer
    # WHY ISNT THIS DONE AT THE END??
    global_offer = global_offer()
    # remove all the unnecessary markup
    clean_up

    # parse all spoilers
    parse_spoilers(global_offer)

    # parse the remanining items
    find_items(post).each do |item|
      set_item_price(item, global_offer)
    end

    true
  end

  # # REMOVE UNLESS I MANAGE TO GET THE ITEM FUCKING ANCESTORS :(
  # def find_price(position)
  #   item = post.at_css("#item-fragment-#{position}")

  #   return unless item

  #   price = get_local_item_price(item)
  #   return price if price

  #   price = find_parent_spoilers_price(item)
  #   return price if price

  #   global_offer
  # end

  # def find_parent_spoilers_price(item)
  #   # Rails.logger.warn item.xpath("ancestor::[@class='spoilerContent']").inspect
  #   # return nil
  # end

  def parse_spoilers(price)
    find_spoilers(post).each do |spoiler|
      parse_spoiler(spoiler, price)
    end
  end

  # Parse a spoiler
  # Starts by finding all the nested spoilers
  # and recursively parse them
  # then parse its own items
  def parse_spoiler(spoiler, price = nil)
    price = spoiler_price(spoiler) || price
    content = spoiler.at_xpath("./div[@class='spoilerContent']")
    return unless content

    spoilers = find_spoilers(content)
    spoilers.each do |sub_spoiler|
      parse_spoiler(sub_spoiler, price)
    end

    items = find_items(content)
    items.each do |item|
      set_item_price(item, price)
    end
  end

  # Parse a price
  # ~b/o [price:float] [orb_name:string]
  def parse_price(price)
    /~(?:(?:gb)|b)\/o ([-+]?[0-9]*\.?[0-9]+) (?:#{orbs_regexp})/.match(price).to_a.compact[1..-1]
  end

  # is this used?
  def self.parse_price(price)
    /([-+]?[0-9]*\.?[0-9]+) (?:#{orbs_regexp})/.match(price).to_a.compact[1..-1]
  end

  # Set the price of an item in the prices array
  # based on his position
  def set_item_price(item, parent_price)
    price = get_local_item_price(item) || parent_price
    return if price.to_a.length < 2
    id = item.attribute("id").try(:value).try(:match, /item-fragment-(\d+)/).try(:[], 1)
    return unless id.present?
    prices[id.to_i] = price
  end

  # [item] ~b/o price
  def get_local_item_price(item)
    sibling = item.next_sibling()
    return unless sibling && sibling.text?
    parse_price(sibling.content)
  end

  # [spoiler value="~b/o price"]
  def spoiler_price(spoiler)
    content = spoiler.first_element_child.first_element_child.content
    parse_price(content)
  end

  # If a global offer is found, set all the prices to it
  # This base value will be overriden by other prices
  def global_offer
    offers = post.xpath("./text()[contains(.,'~gb/o')]")
    offer = offers.first.try(:content)
    return nil unless offer
    parse_price(offer)
  end

  def find_items(node)
    node.xpath("./div[contains(concat(' ',normalize-space(@class),' '),' itemVerified ')]")
  end

  def orbs_regexp
    self.class.orbs_regexp
  end

  def self.orbs_regexp
    @orbs_regexp ||= ORBS.map { |orb| "(?:(#{orb}).*)" }.join("|")
  end

  def find_spoilers(node)
    node.xpath("./div[contains(concat(' ',normalize-space(@class),' '),' spoiler ')]")
  end

  def [](index)
    @prices[index]
  end

  def clean_up
    blacklist = ["br", ".itemSmartLayoutStop"]
    post.css(blacklist.join(", ")).remove
  end

  def first_post(thread)
    thread.css(".forumPostListTable .content-container.first .content").first
  end

end
