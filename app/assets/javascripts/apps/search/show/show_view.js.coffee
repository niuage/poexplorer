@HT.module "SearchApp.Show",
  (Show, HT, Backbone, Marionette, $, _) ->

    @SearchInput = Marionette.ItemView.extend
      el: "#query"

      events:
        "keyup": "onChange"

      initialize: ->
        @listenTo @, "change", @listItems

      onChange: (e) ->
        clearTimeout @timeout if @timeout

        @timeout = setTimeout(=>
          @trigger("change")
        , 200)

      listItems: ->
        HT.trigger("item:list", @$el.val())

    @SearchForm = Marionette.ItemView.extend
      el: '[data-role="search-form"]'

      events:
        "submit": "onSubmit"

      initialize: ->
        @inputView = new Show.SearchInput()

      onSubmit: (e) ->
        e.preventDefault()
        @inputView.trigger("change")

        return false
