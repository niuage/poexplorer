@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    ######################
    # Item Item View #
    ######################
    @Item = Marionette.ItemView.extend
      template: JST["templates/items/list/item"]

      ui:
        actions: ".actions"

      className: "large-12 columns"

      events:
        "click .props li": "onPropClick"
        "click .stats li": "onStatClick"

      initialize: ->
        @listenTo @, "render", @decorate
        @listenTo @, "render", @createButtons

      createButtons: ->
        if @model.get("price").currency
          @ui.actions.append(new List.PriceButton(model: @model).render().$el)

        @ui.actions.append(new List.VerifyButton(model: @model).render().$el)

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

      # update: (query, page) ->
      #   @collection.fetch
      #     reset: true
      #     data:
      #       query: @query(query)
      #       page: page || 1

