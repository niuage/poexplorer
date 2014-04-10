class ItemColorer
  @colors: ["cold", "lightning", "fire", "life", "chaos"]

  @color: ($item) ->
    mods = $item.find(".stats li")
    $.each mods, (i, li) =>
      $li = $(li)
      text = $.trim($li.text())
      for color in @colors
        if text.match(new RegExp(color, "i"))
          $li.wrapInner($("<span>").addClass(color))
          break

      icon = if text.match(/Resistance(s)?$/)
        "fa-shield"
      else if text.match(/to maximum Life/)
        "fa-tint"
      else if text.match(/Damage$/)
        "fa-bolt"

      if icon && !($span = $li.find("span")).length
        $li.wrapInner("<span>")

      if icon
        $li.find("span").prepend("<i class='before fa #{icon}'></i>")



@App.ItemColorer = ItemColorer
