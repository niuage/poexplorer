@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    ######################
    # Item Item View #
    ######################
    @Item = Marionette.ItemView.extend
      template: JST["templates/items/list/item"]

      className: "large-12 columns"

      events:
        "click .props li": "onPropClick"
        "click .stats li": "onStatClick"

      initialize: ->
        @listenTo @, "render", @decorate

      decorate: -> App.ItemRenderer.setup(@$el)

      onStatClick: (e) ->
        e.preventDefault()
        # e.stopPropagation()
        console.log $(e.currentTarget)

      onPropClick: (e) -> @onStatClick(e)

      serializeData: ->
        @model.toViewAttributes()

    ############################
    # Item Collection View #
    ############################
    @Items = Marionette.CollectionView.extend
      childView: List.Item

      className: "items-gallery"

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

