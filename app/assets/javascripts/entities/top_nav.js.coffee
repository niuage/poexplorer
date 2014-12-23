@HT.module "Entities",
  (Entities, HT, Backbone, Marionette, $, _) ->

    @TopNav = Backbone.Model.extend
      initialize: ->
        selectable = new Backbone.Picky.Selectable(@)
        _.extend(@, Backbone.Picky.Selectable.prototype)

    @TopNavCollection = Backbone.Collection.extend
      model: Entities.TopNav,

      initialize: ->
        singleSelect = new Backbone.Picky.SingleSelect(@)
        _.extend(@, Backbone.Picky.SingleSelect.prototype)

    initializeTopNav = ->
      Entities.topNav = new Entities.TopNavCollection([
        { name: "Browse", url: "software", navEvent: "software:list", icon: "bars", button: false },
        { name: "Upload", url: "#", navEvent: "software:index", icon: "upload", button: true },
        { name: "Sign in", url: "#", navEvent: "software:index", icon: "circle-o", button: false }
      ])

    API =
      getTopNavEntities: ->
        if Entities.topNav == undefined
          initializeTopNav()

        Entities.topNav

    HT.reqres.setHandler "topNav:entities", ->
      API.getTopNavEntities()
