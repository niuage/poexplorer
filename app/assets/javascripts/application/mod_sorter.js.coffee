class ModSorter
  constructor: ->
    @$form = $("#search-form")
    @$orderByModInput = @$form.find("#order-by-mod-id")
    @$sortByPrice = @$form.find("#sort-by-price")
    @$results = $("#results")
    @$orderSelect = @$form.find("#order-select")

    @sortOnClick()
    @removeSortingFilter()
    @hightlightCurrentModAndProp()

    @$form.on "itemLoaded", (e) =>
      @hightlightCurrentModAndProp()

  hightlightCurrentModAndProp: ->
    if (mod_id = parseInt(@currentMod()))
      $mods = App.ModHighlighter.selectMods(@$results, [mod_id])
      @highlight($mods)

    if (order = @$orderSelect.val())
      @highlight(@$results.find("[data-sort='#{order}']"))

    if (parseInt(@$sortByPrice.val()))
      @highlight(@$results.find("[data-sort=price]"))

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
      @$form.find("[data-reset-sort='order-by-mod-id']").closest("div").removeClass("hide")
      @sortBy($li.data("mod"))

    @$results.on "click", "[data-sort]", (e) =>
      e.preventDefault()
      $elt = $(e.currentTarget)
      $elt.tooltip('destroy')
      if $elt.data("sort") == "price"
        @$form.find("[data-reset-sort='sort-by-price']").closest("div").removeClass("hide")
        @sortBy(1, @$sortByPrice)
      else
        @$orderSelect.select2("val", $elt.data("sort"))
        @$form.submit()

  removeSortingFilter: ->
    @$form.on "click", "[data-reset-sort]", (e) =>
      e.preventDefault()
      $link = $(e.currentTarget)
      $fieldToReset = @$form.find("##{$link.data("reset-sort")}")
      $link.closest("div").addClass("hide")
      @sortBy(0, $fieldToReset)

  sortBy: (value, $sortInput = null) ->
    ($sortInput || @$orderByModInput).val(value)
    @$form.submit()

  @setup: ->
    new ModSorter()

@App.ModSorter = ModSorter
