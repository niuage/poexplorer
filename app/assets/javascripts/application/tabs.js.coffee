class Tabs
  constructor: (tabs_wrapper) ->
    @$wrapper = $(tabs_wrapper)
    @namespace = @$wrapper.attr("id")
    @$tabs = @$wrapper.find(".btn-group .btn")
    @$selectedTab = @$tabs.filter("[href='#{$.cookie(@namespace)}']")
    @$tabsContent = @$wrapper.find(".tabcontent")

  setup: ->
    currentTab = if @$selectedTab.length > 0 then @$selectedTab else @$tabs.first()
    @select(currentTab)

    @$tabs.on "click", (e) =>
      e.preventDefault()
      $tab = $(e.currentTarget)
      return if $tab.hasClass("active")
      @select($tab)

  select: ($tab) ->
    @$tabs.removeClass("active btn-info")
    $tab.addClass("active btn-info")

    target = $tab.attr("href")
    $.cookie @namespace, target, { path: '/' }
    @$tabsContent.hide().filter("#{target}-fields").show()

    @$selectedTab = $tab

  @setup: (tabs_wrapper) ->
    new Tabs(tabs_wrapper).setup()

@App.Tabs = Tabs
