@HT.module "Common.Views",
  (Views, HT, Backbone, Marionette, $, _) ->

    @Loading = Marionette.ItemView.extend
      template: JST["templates/common/loading"]

      onShow: ->
        $("#spinner").spin
          lines: 13
          length: 0
          width: 12
          radius: 28
          color: "#3C465E"
