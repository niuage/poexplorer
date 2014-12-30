# encoding: UTF-8

League::LEAGUES.each do |league|
  if league == "standard"
    l = League.find_by(name: league).presence || League.find_by(name: "default")
    if l
      l.update_attribute(:name, league)
    else
      l = League.new
      l.name = league
    end
  else
    l = League.where(name: league).first_or_initialize
  end
  l.permanent = true
  l.save
end

League::SEASON_LEAGUES.each do |league|
  l = League.where(name: league).first_or_initialize
  l.permanent = false
  l.save
end

League.where(name: League::LEAGUES + League::SEASON_LEAGUES).all.each_with_index do |l, i|
  l.update_attribute(:hardcore, true) if i % 2 == 1
end

#############################################################

Rarity::FRAME_TYPES.each do |rarity|
  Rarity.where(name: rarity[:name], frame_type: rarity[:frame_type]).first_or_create
end

#############################################################

def create_item_type(type)
  ItemType.where(name: type).first_or_create
end

def create_mod(name)
  Mod.where(name: name).first_or_create
end

def group_for_mod(mod)
  mod_name = mod.name
  return Mod::POPULAR if G_POPULAR_MODIFIERS.include?(mod_name)
  return Mod::CUSTOM  if G_CUSTOM_MODIFIERS.include?(mod_name)
end

def add_mod_to_archetype(type, mod, type_id)
  type_class = type.constantize

  type_sym = case
  when type_class < Weapon; :weapon
  when type_class < Armour; :armour
  when type_class < Misc;   :misc
  end

  mode_item_type = ModItemType.where(
    item_type_id: type_id[type_sym], mod_id: mod.id
  ).first_or_create

  return if !mode_item_type
  mode_item_type.update_attribute(:mod_group, group_for_mod(mod))
end

Item::ARCHETYPES.each do |type|
  create_item_type(type)
end

type_id = {
  weapon: ItemType.find_by(name: "Weapon").id,
  armour: ItemType.find_by(name: "Armour").id,
  misc: ItemType.find_by(name: "Misc").id
}

if false && Rails.env.development?
  user = User.first

  exiles = [
    {
      name: "Exile 1",
      tagline: "I got mangos, in god damn January.",
      description: "Ain't that right Johnny?",
      klass_id: rand(7),
      album_uid: "http://imgur.com/a/FzHdl"
    },
    {
      name: "Exile 2",
      tagline: "I got mangos, in god damn January.",
      description: "Ain't that right Johnny?",
      klass_id: rand(7),
      album_uid: "http://imgur.com/a/XWyKz"
    },
    {
      name: "Exile 3",
      tagline: "I got mangos, in god damn January.",
      description: "Ain't that right Johnny?",
      klass_id: rand(7),
      album_uid: "http://imgur.com/a/kLjHd"
    },
    {
      name: "Exile 4",
      tagline: "I got mangos, in god damn January.",
      description: "Ain't that right Johnny?",
      klass_id: rand(7),
      album_uid: "http://imgur.com/a/zUHSD"
    },
    {
      name: "Exile 5",
      tagline: "I got mangos, in god damn January.",
      description: "Ain't that right Johnny?",
      klass_id: rand(7),
      album_uid: "http://imgur.com/a/mGWRY"
    }
  ]

  exiles.each do |exile|
    Exile.create(exile) do |ex|
      ex.user = user
    end
  end
end

G_MODIFIER_TYPES.each do |mod_name, types|
  mod = create_mod(mod_name)
  types.each do |type|
    type = type.to_s.classify
    item_type = create_item_type(type)
    ModItemType.where(item_type_id: item_type.id, mod_id: mod.id).first_or_create
    add_mod_to_archetype(type, mod, type_id)
  end
end
