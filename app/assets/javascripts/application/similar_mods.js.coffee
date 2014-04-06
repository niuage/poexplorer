class SimilarMods
  constructor: ->
    if $("body").is(".c-items.a-show")
      @mods = @getModsFromItem()
    else
      @mods = @getModsFromForm()

    self = @
    $("#results .stats").each (i, stats) ->
      $(stats).find("li").each (i, stat) ->
        self.addSign($(stat))

  addSign: ($stat) ->
    [modId, modValue] = [$stat.data("mod"), $stat.data("value")]

    searchMod = $.grep @mods, (e, i) -> e[0] == modId
    return unless (searchMod = searchMod[0])

    searchModValue = searchMod[1]

    [sign, klass] = if (searchModValue > modValue)
      ["<", "red"]
    else if (searchModValue < modValue)
      [">", "green"]
    else
      []

    if sign
      $stat.append(" <span class='diff tag tag-#{klass}'>#{modValue} #{sign} #{searchModValue}</span>")

  getModsFromForm: ->
    $.map $("#search-form #stats .nested-fields"), (e, i) ->
      $mod = $(e)
      modValue = $mod.find(".numeric").val()
      [[$mod.data("modId"), parseFloat(modValue)]] if modValue

  getModsFromItem: ->
    $.map $("#item").find(".stats li"), (e, i) ->
      $mod = $(e)
      modValue = $mod.data("value")
      [[$mod.data("mod"), parseFloat(modValue)]] if modValue

  @setup: ->
    new SimilarMods()

@App.SimilarMods = SimilarMods
