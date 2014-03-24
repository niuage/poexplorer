class ItemRenderer
  constructor: (itemSelector) ->
    @$items = $(itemSelector)

  renderItems: ->
    mods = @findMods()
    $.each @$items, (i, item) ->
      $item = $(item)
      App.ItemColorer.color($item)
      App.SocketRenderer.render($item)
      App.ModHighlighter.highlight($item, mods) if mods

  findMods: ->
    searchForm = $("#search-form")
    return unless searchForm.length > 0

    mods = $.map searchForm.find("#stats select"), (e, i) ->
      parseInt($(e).find("option:selected").attr("value"))
    mods

  setup: ->
    return unless @$items.length
    @renderItems()
    @

  @setup: (itemSelector) ->
    new @(itemSelector).setup()

@App.ItemRenderer = ItemRenderer
