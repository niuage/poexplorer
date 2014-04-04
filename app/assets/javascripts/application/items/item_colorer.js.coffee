class ItemColorer
  @colors: ["cold", "lightning", "fire", "life", "chaos"]

  @color: ($item) ->
    mods = $item.find(".stats li")
    $.each mods, (i, li) =>
      $li = $(li)
      text = $li.text()
      for color in @colors
        if text.match(new RegExp(color, "i"))
          $li.wrapInner($("<span>").addClass(color))
          break

      icon = if text.match(/Resistance/)
        "fa-shield"
      else if text.match(/to maximum Life/)
        "fa-tint"

      $li.find("span").prepend("<i class='before fa #{icon}'></i>") if icon



@App.ItemColorer = ItemColorer
