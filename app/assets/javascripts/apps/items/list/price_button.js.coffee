@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    @PriceButton = Marionette.ItemView.extend
      template: JST["templates/items/list/price_button"]

      tagName: "a"

      className: "button"

      attributes:
        "title": "Order by price"
        "data-container": "body"
        "data-sort": "price"

      events:
        click: "onClick"

      onClick: -> alert("click")
