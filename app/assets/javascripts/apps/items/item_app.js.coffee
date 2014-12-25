@HT.module "ItemApp",
  (ItemApp, HT, Backbone, Marionette, $, _) ->

    @Router = Marionette.AppRouter.extend
      appRoutes:
        "": "listItems"
        "i/search/:query": "listItems"
        "i/search": "listItems"
        "i/:id": "showItem"

    API =
      listItems: (query) ->
        ItemApp.List.Controller.listItems(query)
        # HT.execute("set:active:topNavItem", "item")

      showItem: (id) ->
        ItemApp.Show.Controller.showItem(id)
        # HT.execute("set:active:topNavItem", "item")

    HT.addInitializer ->
      new ItemApp.Router(
        controller: API
      )

    HT.on "item:index", ->
      HT.navigate("")
      API.indexItem()

    HT.on "item:list", (query) ->
      HT.navigate("i/search/#{encodeURIComponent(query)}")
      API.listItems(query)

    HT.on "item:show", (id) ->
      HT.navigate "item/#{id}"
      API.showItem(id)
