class Item
  constructor: (@item) ->

  toJson: ->
    id: @item.id
    item_type: @item.item_type
    full_name: @fullName()
    w: @item.w
    h: @item.h
    raw_icon: @item.raw_icon
    sockets: @sockets()
    indexed_at: @item.indexed_at
    requirements: @requirements()
    thread_id: @item.thread_id
    rarity_name: @rarityName()
    visible_stats: @visibleStats()
    isSkill: @isSkill()
    properties: @properties()

  # Helpers

  properties: ->
    props = switch @item.archetype
      when 0 then @weapon_props()
      when 1 then @armour_props()
      when 2 then @misc_props()

    props = props.concat @hiddenStats()

    $.map props, (prop, i) ->
      prop if prop && prop.value > 0

  weapon_props: ->
    [
      { name: "DPS", value: @item.dps, meta_data: "dps", data_attr: "sort" }
      { name: "pDPS", value: @item.physical_dps, meta_data: "physical_dps", data_attr: "sort" }
      { name: "APS", value: @item.aps, meta_data: "aps", data_attr: "sort" }
    ].concat @weapon_and_misc_props()

  armour_props: ->
    [
      { name: "Evasion", value: @item.evasion, meta_data: "evasion", data_attr: "sort" }
      { name: "Armour", value: @item.armour, meta_data: "armour", data_attr: "sort" }
      { name: "ES", value: @item.energy_shield, meta_data: "energy_shield", data_attr: "sort" }
      { name: "% Chance to Block", value: @item.block_chance, meta_data: "block_chance", data_attr: "sort" }
    ]

  misc_props: ->
    @weapon_and_misc_props()

  weapon_and_misc_props: ->
    [
      { name: "Physical Dmg", value: @displayedPhysDmg(), meta_data: "physical_damage", data_attr: "sort" }
      { name: "Elemental Dmg", value: @item.elemental_damage, meta_data: "elemental_damage", data_attr: "sort" }
      { name: "CS Chance", value: @item.critical_strike_chance, meta_data: "critical_strike_chance", data_attr: "sort" }
    ]

  displayedPhysDmg: ->
    if @item.raw_physical_damage
      "#{@item.raw_physical_damage} (#{@item.physical_damage})"
    else
      @item.physical_damage

  hiddenStats: ->
    $.map @item.stats, (stat, i) ->
      if stat.hidden
        name: stat.name
        value: stat.value
        data_attr: "mod"
        meta_data: stat.mod_id

  requirements: ->
    Item.templates["requirements"](
      league_name: @capitalize(@item.league_name)
      requires_level: if @item.item_type ==  "Map" then "Level" else "Requires level"
      level: @item.level
      required_stats: @requiredStats()
      quality: @item.quality
    )

  requiredStats: ->
    ["dex", "str", "int"].map (stat, i) =>
      if (stat_value = @item[stat])
        stat: stat
        value: stat_value

  fullName: ->
    @item.full_name

  rarityName: ->
    @item.rarity_name.toLowerCase()

  visibleStats: ->
    $.map @item.stats, (stat, i) ->
      unless stat.hidden
        stat["klass"] = "implicit" if stat.implicit
        stat

  sockets: ->
    JSON.stringify(@item.sockets)

  isSkill: ->
    @item.item_type == "Skill"

  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  @cacheTemplates: ->
    return if @templatesCached

    @templatesCached = true
    Item.templates = {}
    Item.templates["requirements"] = Handlebars.compile($("#requirements-template").html())

  @create: (item) ->
    new Item(item)

@App.Item = Item
