@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    @Controller =
      listItems: (query) ->
        # HT.mainRegion.show(new HT.Common.Views.Loading())

        itemsRequest = HT.request("item:entities", query) # should pass query here?

        $.when(itemsRequest).done (itemCollection) ->

          itemListView = new List.Items(
            collection: itemCollection
          )

          # create a view for that
          # itemCollection.totalCount

          itemListView.on "childview:item:show", (childView, model) ->
            HT.trigger("item:show", model.get("id"))

          HT.mainRegion.show(itemListView)
