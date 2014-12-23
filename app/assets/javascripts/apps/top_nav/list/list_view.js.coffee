@HT.module "TopNavApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    @TopNavItem = Marionette.ItemView.extend
      template: JST["templates/top_nav/top_nav_link"]
      tagName: "li"

      events:
        click: "navigate"

      navigate: (e) ->
        e.preventDefault()
        @trigger("navigate", @model)

      onRender: ->
        if @model.selected
          @$el.addClass("current")

    @TopNav = Marionette.CompositeView.extend
      template: JST["templates/top_nav/top_nav"],
      childView: List.TopNavItem,
      childViewContainer: "ul"

      events:
        "click h1 a": "titleClicked"

      titleClicked: (e) ->
        e.preventDefault()
        @trigger("title:clicked")
