@HT.module "Entities",
  (Entities, HT, Backbone, Marionette, $, _) ->

    @Item = Backbone.Model.extend
      url: ->
        "http://api.platform.dev/#{@itemPath()}"

      itemPath: ->
        "/items/" + @get("id")

      toViewAttributes: ->
        _.extend({}, @toJSON(),
          rarity_name: @rarityName()
          base_name: @baseName()
          reqs: @requirements()
          is_skill: @isSkill()
          visible_stats: @visibleStats()
          properties: @properties()
          sockets: @sockets()
        )

      parse: (response) ->
        return response.items if response.items
        response

      rarityName: -> @get("rarity_name").toLowerCase()

      baseName: ->
        baseName = @get("base_name")
        if baseName != @get("name") then baseName else ""

      requirements: ->
        league_name: @capitalize(@get("league_name"))
        requires_level: if @get("item_type") ==  "Map" then "Level" else "Requires level"
        level: @get("level")
        required_stats: @requiredStats()
        quality: @get("quality")

      requiredStats: ->
        $.map ["dex", "str", "int"], (stat, i) =>
          if (stat_value = @get(stat))
            stat: stat
            value: stat_value

      visibleStats: ->
        $.map @get("stats"), (stat, i) ->
          unless stat.hidden
            stat["klass"] = "implicit" if stat.implicit
            stat

      isSkill: -> @get("item_type") == "Skill"

      properties: ->
        props = switch @get("archetype")
          when 0 then @weapon_props()
          when 1 then @armour_props()
          when 2 then @misc_props()

        props = props.concat @hiddenStats()

        $.map props, (prop, i) ->
          prop if prop && prop.value > 0

      weapon_props: ->
        [
          { name: "DPS", value: @get("dps"), meta_data: "dps", data_attr: "sort" }
          { name: "pDPS", value: @get("physical_dps"), meta_data: "physical_dps", data_attr: "sort" }
          { name: "APS", value: @get("aps"), meta_data: "aps", data_attr: "sort" }
        ].concat @weapon_and_misc_props()

      armour_props: ->
        [
          { name: "Evasion", value: @get("evasion"), meta_data: "evasion", data_attr: "sort" }
          { name: "Armour", value: @get("armour"), meta_data: "armour", data_attr: "sort" }
          { name: "ES", value: @get("energy_shield"), meta_data: "energy_shield", data_attr: "sort" }
          { name: "% Chance to Block", value: @get("block_chance"), meta_data: "block_chance", data_attr: "sort" }
        ]

      misc_props: ->
        @weapon_and_misc_props()

      weapon_and_misc_props: ->
        [
          { name: "Physical Dmg", value: @displayedPhysDmg(), meta_data: "physical_damage", data_attr: "sort" }
          { name: "Elemental Dmg", value: @get("elemental_damage"), meta_data: "elemental_damage", data_attr: "sort" }
          { name: "CS Chance", value: @get("csc"), meta_data: "csc", data_attr: "sort" }
        ]

      displayedPhysDmg: ->
        if @get("raw_physical_damage")
          "#{@get("raw_physical_damage")} (#{@get("physical_damage")})"
        else
          @get("physical_damage")

      hiddenStats: ->
        $.map @get("stats"), (stat, i) ->
          if stat.hidden
            name: stat.name
            value: stat.value
            data_attr: "mod"
            meta_data: stat.mod_id

      sockets: -> JSON.stringify(@get("sockets"))

      capitalize: (string) ->
        string.charAt(0).toUpperCase() + string.slice(1)

    @getItem = (id) ->
      item = new Entities.Item(id: id)
      defer = $.Deferred()

      item.fetch
        success: (data) -> defer.resolve(data)
        error:          -> defer.resolve(undefined)

      defer.promise()

@HT.reqres.setHandler "item:entity", (id) ->
  @HT.Entities.getItem(id)
