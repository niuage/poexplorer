@HT.module "SearchApp.Show",
  (Show, HT, Backbone, Marionette, $, _) ->

    @SearchInput = Marionette.ItemView.extend
      el: "#fast_search_query"

      events:
        "keyup": "onChange"

      onChange: ->
        clearTimeout @timeout if @timeout

        @timeout = setTimeout(=>
          HT.trigger("item:list", @$el.val())
        , 200)
