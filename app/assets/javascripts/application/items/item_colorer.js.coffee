class ItemColorer
  @colors: ->
    ["cold", "lightning", "fire", "life", "chaos"]

  @color: ($item) ->
    mods = $item.find(".stats li")
    $.each mods, (i, li) =>
      $li = $(li)
      text = $li.text()
      for color in @colors()
        if text.match(new RegExp(color, "i"))
          $li.wrapInner($("<span>").addClass(color))
          if text.match(new RegExp("Resistance"))
            $li.find("span").prepend("<i class='before fa fa-shield'></i>")



@App.ItemColorer = ItemColorer
