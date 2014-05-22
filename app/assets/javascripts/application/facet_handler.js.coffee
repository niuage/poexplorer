class FacetHandler
  constructor: ->

  @clicks:
    rarity: =>
      self = @
      $select = @$form.find("#rarity-select")
      facetName = @$e.find(".facet-name").text()

      val = $select.find("option").filter(->
        $(@).html() == facetName
      ).val()

      $select.select2("val", val)
      @$form.submit()

    linked_sockets: =>
      $sc =  @$form.find(".select_linked_socket_count")
      $msc = @$form.find(".select_max_linked_socket_count")

      facetName = @$e.find(".facet-name").text()

      $sc.val(facetName).change()
      $msc.val(facetName).change()
      @$form.submit()

    item_type: =>
      $select = @$form.find("#item-type-select")
      facetName = @$e.find(".facet-name").text()

      val = $select.find("option[value='#{facetName}']").val()

      $select.select2("val", val)
      @$form.submit()

    name: =>
      $select = @$form.find("#base-name-select")
      facetName = @$e.find(".facet-name").text()

      val = $select.find("option[value='#{facetName}']").val()

      $select.select2("val", val)
      @$form.submit()

  @resets:
    rarity: =>
      @$form.find("#rarity-select").select2("val", "")
      @$form.submit()

    linked_sockets: =>
      $sc =  @$form.find(".select_linked_socket_count")
      $msc = @$form.find(".select_max_linked_socket_count")

      $sc.val("").change()
      $msc.val("").change()
      @$form.submit()

    item_type: =>
      @$form.find("#item-type-select").select2("val", "")
      @$form.submit()

    name: =>
      @$form.find("#base-name-select").select2("val", "")
      @$form.submit()

  @click: (event, @$form) ->
    @$e = $(event.currentTarget)
    facetName = @$e.closest("[data-name]").data("name")

    @clicks[facetName]()

  @reset: (event, @$form) ->
    @$e = $(event.currentTarget)
    facetName = @$e.closest("[data-name]").data("name")

    @resets[facetName]()

@App.FacetHandler = FacetHandler
