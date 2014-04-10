# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

["Duelist", "Marauder", "Ranger", "Shadow", "Templar", "Witch", "Scion"].each do |klass_name|
  k = Klass.where(name: klass_name).first_or_initialize
  k.save
end

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

G_MODIFIER_TYPES.each do |mod_name, types|
  mod = create_mod(mod_name)
  types.each do |type|
    type = type.to_s.classify
    item_type = create_item_type(type)
    ModItemType.where(item_type_id: item_type.id, mod_id: mod.id).first_or_create
    add_mod_to_archetype(type, mod, type_id)
  end
end

[{"id"=>24426, "icon"=>"Art/2DArt/SkillIcons/passives/ghostreaver.png", "dn"=>"Ghost Reaver", "sd"=>["Life Leech applies to Energy Shield instead of Life"]}, {"id"=>54307, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneAcrobatics.png", "dn"=>"Acrobatics", "sd"=>["20% Chance to Dodge Attacks. 50% less Armour and Energy Shield"]}, {"id"=>18663, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneMinionInstability.png", "dn"=>"Minion Instability", "sd"=>["Minions explode when reduced to low life, dealing 33% of their maximum life as fire damage to surrounding enemies"]}, {"id"=>23540, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneConduit.png", "dn"=>"Conduit", "sd"=>["Share Endurance, Frenzy and Power Charges with nearby party members"]}, {"id"=>10808, "icon"=>"Art/2DArt/SkillIcons/passives/vaalpact.png", "dn"=>"Vaal Pact", "sd"=>["Life Leech applies instantly. Life Regeneration and Life Recovery from Flasks have no effect."]}, {"id"=>11455, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneChaosInoculation.png", "dn"=>"Chaos Inoculation", "sd"=>["Maximum Life becomes 1, Immune to Chaos Damage"]}, {"id"=>14896, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneHexMaster.png", "dn"=>"Hex Master", "sd"=>["Curses you Cast never expire"]}, {"id"=>10661, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneIronReflexes.png", "dn"=>"Iron Reflexes", "sd"=>["Converts all Evasion Rating to Armour. Dexterity provides no bonus to Evasion Rating"]}, {"id"=>40907, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneUnwaveringStance.png", "dn"=>"Unwavering Stance", "sd"=>["Cannot Evade enemy Attacks", "Cannot be Stunned"]}, {"id"=>56075, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneEldritchBattery.png", "dn"=>"Eldritch Battery", "sd"=>["Converts all Energy Shield to Mana"]}, {"id"=>31961, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneResoluteTechnique.png", "dn"=>"Resolute Technique", "sd"=>["Your hits can't be Evaded", "Never deal Critical Strikes"]}, {"id"=>63425, "icon"=>"Art/2DArt/SkillIcons/passives/liferegentoenergyshield.png", "dn"=>"Zealot's Oath", "sd"=>["Life Regeneration applies to Energy Shield instead of Life"]}, {"id"=>57279, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneBloodMagic.png", "dn"=>"Blood Magic", "sd"=>["Removes all mana. Spend Life instead of Mana for Skills"]}, {"id"=>31703, "icon"=>"Art/2DArt/SkillIcons/passives/KeystonePainAttunement.png", "dn"=>"Pain Attunement", "sd"=>["30% more Spell Damage when on Low Life"]}, {"id"=>54922, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneArrowDodging.png", "dn"=>"Ondar's Guile", "sd"=>["Doubles chance to Evade Projectile Attacks"]}, {"id"=>42178, "icon"=>"Art/2DArt/SkillIcons/passives/KeystonePointBlankArcher.png", "dn"=>"Point Blank", "sd"=>["Projectile Attacks deal up to 50% more Damage to very close targets, but deal less Damage to farther away targets"]}, {"id"=>12926, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneIronGrip.png", "dn"=>"Iron Grip", "sd"=>["The increase to Physical Damage from Strength applies to Projectile Attacks as well as Melee Attacks"]}, {"id"=>39085, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneElementalEquilibrium.png", "dn"=>"Elemental Equilibrium", "sd"=>["Enemies you hit with Elemental Damage temporarily get +25% Resistance to those Elements and -50% Resistance to other Elements"]}, {"id"=>45175, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneNecromanticAegis.png", "dn"=>"Necromantic Aegis", "sd"=>["All bonuses from an equipped Shield apply to your Minions instead of you"]}, {"id"=>14914, "icon"=>"Art/2DArt/SkillIcons/passives/KeystonePhaseAcrobatics.png", "dn"=>"Phase Acrobatics", "sd"=>["20% Chance to Dodge Spell Damage"]}, {"id"=>22535, "icon"=>"Art/2DArt/SkillIcons/passives/KeystoneWhispersOfDoom.png", "dn"=>"Whispers of Doom", "sd"=>["Enemies can have 1 additional Curse"]}, {"id"=>41970, "icon"=>"Art/2DArt/SkillIcons/passives/totemmax.png", "dn"=>"Ancestral Bond", "sd"=>["Can summon up to 1 additional totem", "You can't deal Damage with your Skills yourself"]}].each do |keystone|
  k = Keystone.where(uid: keystone["id"]).first_or_initialize
  k.uid = keystone["id"]
  k.name = keystone["dn"]
  k.description = keystone["sd"].join(Keystone::SEPARATOR) if keystone["sd"]
  k.icon = keystone["icon"]
  k.save
end
