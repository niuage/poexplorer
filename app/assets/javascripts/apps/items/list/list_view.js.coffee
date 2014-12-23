@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    ######################
    # Item Item View #
    ######################
    @Item = Marionette.ItemView.extend
      template: JST["templates/items/list/item"]

      events:
        click: "onClick"

      onClick: (e) ->
        e.preventDefault()
        # e.stopPropagation()
        @trigger("item:show", @model)

      serializeData: ->
        @model.toViewAttributes()

    ############################
    # Item Collection View #
    ############################
    @Items = Marionette.CollectionView.extend
      childView: List.Item

      className: "items-gallery row"

      # initialize: ->
        # @listenTo @collection, "reset", @render
        # @update()

      update: (query, page) ->
        @collection.fetch
          reset: true
          data:
            query: @query(query)
            page: page || 1

      query: (query) ->
        query ||= ""
        "has:video #{query}"

