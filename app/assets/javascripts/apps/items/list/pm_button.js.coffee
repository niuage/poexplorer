@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    @PmButton = Marionette.ItemView.extend
      template: JST["templates/items/list/pm_button"]

      tagName: "a"

      className: "send-pm button"

      events:
        click: "onClick"

      onClick: -> alert("click")
