@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    ######################
    # Item Item View #
    ######################
    @Item = Marionette.ItemView.extend
      template: JST["templates/items/list/item"]

      className: "large-12 columns"

      events:
        click: "onClick"

      initialize: ->
        @listenTo @, "render", @decorate

      decorate: -> App.ItemRenderer.setup(@$el)

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

      initialize: ->
        @listenTo @, "render:collection", @decorateItems

      decorateItems: ->
        # App.ItemVerification.setup({ root: $(".result").closest("div") })
        # App.OnlineStatus.accountStatuses("#results")
        # App.PM.setup("#results")

      # update: (query, page) ->
      #   @collection.fetch
      #     reset: true
      #     data:
      #       query: @query(query)
      #       page: page || 1

