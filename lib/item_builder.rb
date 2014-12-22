require 'digest/md5'

class ItemBuilder
  attr_accessor \
    :poe_item, :item,
    :thread, :thread_updated_at, :forum_thread,
    :price, :update_prices

  def initialize(poe_item, price, forum_thread)
    @log = []
    @forum_thread = forum_thread
    @price = price
    @thread_updated_at = forum_thread.last_updated_at

    @poe_item = poe_item

    log thread_id
  end

  def build
    attributes = {
      name: name,
      base_name: type_line,

      league: league,
      rarity: rarity,
      account: account,
      raw_icon: poe_item["icon"],

      quality: property("Quality").to_i,
      csc: property("Critical Strike Chance"),

      block_chance: property("Chance to Block"),

      level: item.map? ? property("Map Level") : requirement("Level"),
      str: requirement("Str"),
      dex: requirement("Dex"),
      int: requirement("Int"),

      identified: poe_item["identified"],
      verified: true,

      w: poe_item["w"],
      h: poe_item["h"],

      thread_id: thread_id,

      corrupted: corrupted?
    }

    if item.armour?
      attributes.merge!(
        armour: property("Armour"),
        evasion: property("Evasion Rating"),
        energy_shield: property("Energy Shield")
      )
    end

    if item.weapon?
      attributes.merge!(
        raw_physical_damage: fetch_raw_value(properties, "Physical Damage"),
        physical_damage: property("Physical Damage"),
        aps: property("Attacks per Second")
      )
    end

    if item.has_sockets?
      socket_collection = SocketCollection.new(poe_item["sockets"])

      attributes.merge!(
        sockets: socket_collection.sockets,
        socket_count: socket_collection.socket_count,
        linked_socket_count: socket_collection.linked_socket_count,
        socket_combination: socket_collection.socket_combination
        )
    end

    item.assign_attributes attributes

    item.price = price if update_prices

    item.uid = md5
    item.indexed_at = Time.zone.now
    item.thread_updated_at = thread_updated_at

    build_stats
    true
  end

  def save
    return flush_log if scrawled?

    initialize_item
    if item.nil?
      log thread_id
      log poe_item, flush: true
      log_failed_item(poe_item)
      return false
    end

    build && flush_log && item.save
  end

  def self.item_verified?(item)
    item["verified"]
  end

  def self.md5(item)
    verified = item.delete("verified")
    md5 = Digest::MD5.hexdigest(item.to_s)
    item["verified"] = verified

    md5
  end

  def league
    League.find_by(name: poe_item["league"].downcase)
  end

  private

  def build_stats
    StatBuilder.new(item, implicit_mods, explicit_mods).build unless item.skill?
  end

  def fetch_value(objects, value, identifier = "name")
    raw_value = fetch_raw_value(objects, value, identifier = "name")
    return unless raw_value
    parse_value(raw_value)
  end

  def fetch_raw_value(objects, value, identifier = "name")
    return nil unless objects
    objects.each do |obj|
      return obj["values"][0].try(:[], 0) if obj[identifier] == value
    end
    nil
  end

  def property(property_name)
    fetch_value(properties, property_name)
  end

  def requirement(requirement_name)
    req = fetch_value(requirements, requirement_name)
    req ? req.to_i : nil
  end

  def parse_value(value)
    if (v = value.match /(\d+)-(\d+)/)
      (v[1].to_f + v[2].to_f) / 2
    elsif (v = value.match /([-+]?[0-9]*\.?[0-9]+)%?/)
      v[1].to_f
    end
  end

  def initialize_item
    item_type = get_item_type
    return false unless Item::TYPES.include?(item_type)
    @item = item_type.classify.constantize.new
  end

  # get the item_type from its base name (typeLine)
  def get_item_type
    base_name = type_line
    G_BASE_NAMES.each_pair do |categorie, types|
      types.each_pair do |type, base_names|
        if base_names.find { |bn| base_name.include?(bn) }
          log type
          return type.classify
        end
      end
    end
    nil
  end

  def rarity
    Rarity.by_frame_type(poe_item["frameType"]).first
  end

  def thread_id
    forum_thread.uid
  end

  def account
    forum_thread.account
  end

  def explicit_mods
    poe_item["explicitMods"]
  end

  def implicit_mods
    poe_item["implicitMods"]
  end

  def md5
    self.class.md5(poe_item)
  end

  def properties
    @item_properties ||= poe_item["properties"]
  end

  def requirements
    @requirements ||= poe_item["requirements"]
  end

  def name
    # gems and white/magic items just have a typeLine
    poe_item["name"].present? ? poe_item["name"] : type_line
  end

  def type_line
    # I would actually have to go through all the base_names and get the one that match
    # because sometimes, the type line can be "Virile Leather Belt of the Furnace"
    # instead of Leather Belt... :(
    # or I could remove the name when it's equal to the typeline
    poe_item["typeLine"]
  end

  def corrupted?
    poe_item["corrupted"]
  end

  def find_item_by_uid(uid)
    Item.where(uid: uid, thread_id: thread_id).first
  end

  def scrawled?
    if item = find_item_by_uid(md5)
      log "item id: #{item.id}"
      log "updating price: #{update_prices} | #{price}" if update_prices
      item.price = price if update_prices
      item.save
      return true
    end

    false
  end

  def log log, options = {}
    return puts(log) if options[:flush] && logging?
    @log << log
  end

  def flush_log
    puts @log.join(" -- ") if logging?
    true
  end

  def logging?
    !Rails.env.production?
  end

  def log_failed_item poe_item
    File.open("/tmp/failed_items_log.txt", "a+") do |f|
      f << thread_id
      f << "\n"
      f << poe_item
      f << "\n\n"
    end unless poe_item["icon"].include?("Currency")
  end

end
