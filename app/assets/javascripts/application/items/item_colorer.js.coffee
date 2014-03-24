class ItemColorer
  @colors: ->
    ["cold", "lightning", "fire", "life"]

  @color: ($item) ->
    mods = $item.find(".stats li")
    $.each mods, (i, li) =>
      $li = $(li)
      text = $li.html()
      for color in @colors()
        if text.match(new RegExp(color, "i"))
          $li.wrapInner($("<span>").addClass(color))

@App.ItemColorer = ItemColorer
