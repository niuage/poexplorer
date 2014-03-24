class ModHighlighter
  @highlight: ($container, mods) ->
    $itemMods = @selectMods($container, mods)
    @highlightMods($itemMods)

  @highlightMods: ($itemMods) ->
    $itemMods.wrapInner($("<span>").addClass("tag"))

  @selectMods: ($container, mod_ids) ->
    selector = $.map(mod_ids, (mod_id, i) ->
      ".stats li[data-mod=#{mod_id}]"
    ).join(",")

    $container.find(selector)

  @highlightAll: (source, items) ->
    [self, $source, $items] = [@, $(source), $(items)]

    mod_ids = $.map $source.find(".stats li"), (e, i) ->
      $(e).data("mod")

    @highlightMods(@selectMods($items, mod_ids))

@App.ModHighlighter = ModHighlighter
