#= require ./item

@HT.module(
  "Entities",
  (Entities, ContactManager, Backbone, Marionette, $, _) ->

    @ItemCollection = Backbone.Collection.extend
      initialize: (models, options = {}) ->
        @query = options.query
        @totalCount = 0

      url: -> "http://localhost:8080/i/search/#{@query}"

      model: HT.Entities.Item

      parse: (response) ->
        @totalCount = response.total_count
        response.items

    # query = null
    itemCollection = null

    @getItemCollection = (q) ->
      query = if q then decodeURIComponent(q) else ""
      itemCollection = new Entities.ItemCollection(null, query: query)


      defer = $.Deferred()

      itemCollection.fetch
        reset: true
        success: (data) -> defer.resolve(itemCollection)
        error:          -> defer.resolve(undefined)

      defer.promise()
)

@HT.reqres.setHandler "item:entities", (query) ->
  @HT.Entities.getItemCollection(query)
