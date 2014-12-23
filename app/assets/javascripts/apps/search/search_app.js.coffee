@HT.module "SearchApp",
  (SearchApp, HT, Backbone, Marionette, $, _) ->

    SearchApp.on "start", ->
      new SearchApp.Show.SearchInput()
