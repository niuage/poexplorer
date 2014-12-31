@HT.module "ItemApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    @VerifyButton = Marionette.ItemView.extend
      template: JST["templates/items/list/verify_button"]

      tagName: "a"

      className: "button"

      events:
        click: "onClick"

      onClick: -> alert("click")
