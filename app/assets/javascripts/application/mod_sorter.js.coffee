class ModSorter
  constructor: ->
    @$form = $("#search-form")
    @$orderByModInput = @$form.find("#order-by-mod-id")
    @$results = $("#results")
    @$orderSelect = @$form.find("#order-select")

    @sortOnClick()
    @removeSortingFilter()
    @hightlightCurrentModAndProp()

  hightlightCurrentModAndProp: ->
    if (mod_id = @currentMod())
      $mods = App.ModHighlighter.selectMods(@$results, [mod_id])
      @highlight($mods)

    if (order = @$orderSelect.val())
      @highlight(@$results.find("[data-sort=#{order}]"))


  highlight: ($elts) ->
    $elts
      .addClass("sorting")
      .prepend("<i class='dex fa fa-chevron-down'></i> ")

  currentMod: ->
    @$orderByModInput.val()

  sortOnClick: ->
    @$results.find(".stats li").on "click", (e) =>
      $li = $(e.currentTarget)
      @sortByMod($li.data("mod"))

    @$results.find("[data-sort]").on "click", (e) =>
      $elt = $(e.currentTarget)
      @$orderSelect.val($elt.data("sort"))
      @$form.submit()

  removeSortingFilter: ->
    @$form.on "click", "[data-mod-sort=remove]", (e) =>
      e.preventDefault()
      $link = $(e.currentTarget)
      $link.html("Removing filter...")
      @sortByMod("")

  sortByMod: (modId) ->
    @$orderByModInput.val(modId)
    @$form.submit()

  @setup: ->
    new ModSorter()

@App.ModSorter = ModSorter
