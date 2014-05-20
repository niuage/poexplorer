class FacetHandler
  constructor: ->

  @clicks:
    rarity: =>
      self = @
      $select = @$form.find("#rarity-select")
      text = @$e.find(".facet-name").text()

      val = $select.find("option").filter(->
        $(@).html() == text
      ).val()

      $select.select2("val", val)
      @$form.submit()

    linked_sockets: =>
      alert("linked_sockets")

    item_type: =>
      alert("item_type")

    name: =>
      alert("name")

  @resets:
    rarity: =>
      @$form.find("#rarity-select").select2("val", "")
      @$form.submit()

  @click: (event, @$form) ->
    event.preventDefault()
    @$e = $(event.currentTarget)
    facetName = @$e.closest("[data-name]").data("name")

    @clicks[facetName]()

  @reset: (event, @$form) ->
    event.preventDefault()
    @$e = $(event.currentTarget)
    facetName = @$e.closest("[data-name]").data("name")

    @resets[facetName]()

@App.FacetHandler = FacetHandler
