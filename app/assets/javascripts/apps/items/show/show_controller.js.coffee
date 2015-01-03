HT.module "ItemApp.Show",
  (Show, HT, Backbone, Marionette, $, _) ->

    @Controller =
      showSoftware: (slug) ->
        HT.mainRegion.show(new HT.Common.Views.Loading())

        modelRequest = HT.request("item:entity", slug)

        $.when(modelRequest).done (item) ->
          itemView = new Show.Item(model: item)
          HT.mainRegion.show(itemView)
