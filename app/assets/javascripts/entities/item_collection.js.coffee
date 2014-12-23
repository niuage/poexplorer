#= require ./item

@HT.module(
  "Entities",
  (Entities, ContactManager, Backbone, Marionette, $, _) ->

    @ItemCollection = Backbone.Collection.extend
      # url: "http://api.platform.dev/item"

      model: HT.Entities.Item

      parse: (response) ->
        response

    itemCollection = null

    @getItemCollection = (query) ->
      itemCollection = new Entities.ItemCollection()
      defer = $.Deferred()

      query = if query then encodeURIComponent(query) else ""

      itemCollection.fetch
        url: "http://localhost:8080/i/search/#{query}"
        reset: true
        success: (data) -> defer.resolve(data)
        error:          -> defer.resolve(undefined)

      defer.promise()
)

@HT.reqres.setHandler "item:entities", (query) ->
  @HT.Entities.getItemCollection(query)
