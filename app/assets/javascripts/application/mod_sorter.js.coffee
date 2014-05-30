class ModSorter
  constructor: ->
    @$form = $("#search-form")
    @$orderByModInput = @$form.find("#order-by-mod-id")
    @$results = $("#results")
    @$orderSelect = @$form.find("#order-select")

    @sortOnClick()
    @removeSortingFilter()
    @hightlightCurrentModAndProp()

    @$form.on "itemLoaded", (e) =>
      @hightlightCurrentModAndProp()

  hightlightCurrentModAndProp: ->
    if (mod_id = @currentMod())
      $mods = App.ModHighlighter.selectMods(@$results, [mod_id])
      @highlight($mods)

    if (order = @$orderSelect.val())
      @highlight(@$results.find("[data-sort='#{order}']"))

  highlight: ($elts) ->
    $elts
      .filter(":not(.btn)")
      .addClass("sorting")
      .end()
      .prepend("<i class='dex fa fa-chevron-down'></i> ")

  currentMod: ->
    @$orderByModInput.val()

  sortOnClick: ->
    @$results.on "click", ".stats li[data-mod], .props li[data-mod]", (e) =>
      $li = $(e.currentTarget)
      @$form.find("[data-mod-sort=remove]").closest("div").removeClass("hide")
      @sortByMod($li.data("mod"))

    @$results.on "click", "[data-sort]", (e) =>
      $elt = $(e.currentTarget)
      $elt.tooltip('destroy')
      @$orderSelect.select2("val", $elt.data("sort"))
      @$form.submit()

  removeSortingFilter: ->
    @$form.on "click", "[data-mod-sort=remove]", (e) =>
      e.preventDefault()
      $link = $(e.currentTarget)
      $link.closest("div").addClass("hide")
      @sortByMod("")

  sortByMod: (modId) ->
    @$orderByModInput.val(modId)
    @$form.submit()

  @setup: ->
    new ModSorter()

@App.ModSorter = ModSorter
