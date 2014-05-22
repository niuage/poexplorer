class Layout
  constructor: ->
    @$layouts = $(".layouts")
    @$body = $("body")
    @loadingClass = "fa-spinner fa-spin"

    @click()

  click: ->
    @$layouts.on "click", ".view-layout", (e) =>
      e.preventDefault()
      return if @working

      $layout = $(e.currentTarget)

      @beforeChange($layout)

      type = $layout.data("type")
      layoutValue = $layout.data("layout")

      # sets the attributes of the body
      # data-size="s" || data-time="day"
      (attr = {}) && attr["data-#{type}"] = layoutValue
      @$body.attr(attr)

      # set the current
      @$layouts.find(".current[data-type=#{type}]").removeClass("current")
      $layout.addClass("current")

      console.log("what's happening?")

      $.ajax
        url: "/users/update_layout"
        dataType: "json"
        data:
          layout: $layout.data("layout")
        complete: => @afterChange($layout)

  beforeChange: ($layout) ->
    @working = true
    $layout.find("i").addClass(@loadingClass)

  afterChange: ($layout) ->
    @working = false
    $layout.find("i").removeClass(@loadingClass)

  @setup: ->
    new Layout()

@App.Layout = Layout
