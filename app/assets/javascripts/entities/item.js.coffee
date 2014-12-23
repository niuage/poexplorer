@HT.module "Entities",
  (Entities, HT, Backbone, Marionette, $, _) ->

    @Item = Backbone.Model.extend
      url: ->
        "http://api.platform.dev/#{@itemPath()}"

      itemPath: ->
        "/items/" + @get("id")

      toViewAttributes: ->
        @toJSON()

      parse: (response) ->
        return response.items if response.items
        response

    @getItem = (id) ->
      item = new Entities.Item(id: id)
      defer = $.Deferred()

      item.fetch
        success: (data) -> defer.resolve(data)
        error:          -> defer.resolve(undefined)

      defer.promise()

@HT.reqres.setHandler "item:entity", (id) ->
  @HT.Entities.getItem(id)
