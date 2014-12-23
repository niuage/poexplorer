@HT.module "TopNavApp.List",
  (List, HT, Backbone, Marionette, $, _) ->

    @Controller =
      listTopNav: ->
        links = HT.request("topNav:entities")

        topNav = new List.TopNav
          collection: links

        topNav.on "title:clicked", ->
          HT.trigger("software:index")

        topNav.on "childview:navigate", (childView, navItem) ->
          HT.trigger(navItem.get("navEvent"))

        HT.topNavRegion.show(topNav)

      setCurrentNavItem: (url) ->
        navItems = HT.request("topNav:entities")
        currentItem = navItems.find (navItem) ->
          navItem.get("url") == url

        if currentItem
          currentItem.select()
        else
          navItems.deselect()

        navItems.trigger("reset")

