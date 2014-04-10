class ItemColorer
  @colors: [
    "cold"
    "lightning"
    "fire"
    "maximum life"
    "chaos"
    "spell"
    "physical"
    "speed"
  ]

  @colorRegexp: new RegExp("(" + @colors.join("|") + ")", "i")

  @iconRegexps:
    resistances: /Resistance(s)?$/
    life: /to maximum Life/
    damage: /(?:Adds.*Damage|increased (?:Spell|Physical) Damage)$/

  @color: ($item) ->
    mods = $item.find(".stats li")
    $.each mods, (i, li) =>
      $li = $(li)
      text = $.trim($li.text())

      if colorMatch = text.match(@colorRegexp)
        $li.wrapInner($("<span>").addClass(colorMatch[0].toLowerCase().replace(" ", "_")))

      icon = if text.match(@iconRegexps.resistances)
        "fa-shield"
      else if text.match(@iconRegexps.life)
        "fa-tint"
      else if text.match(@iconRegexps.damage)
        "fa-bolt"

      if icon && !($span = $li.find("span")).length
        $li.wrapInner("<span>")

      if icon
        $li.find("span").prepend("<i class='before fa #{icon}'></i>")

@App.ItemColorer = ItemColorer
