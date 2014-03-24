class BuildForm
  constructor: ->
    @$form = $("#build-form")
    @$gems = $(".gems-select")
    @colors = { int: "b", str: "r", dex: "g", gen: "w" }
    @$tabs = $(".nav-tabs")

  setup: ->
    @setupTabs()
    @setupSelect2()
    @updateGems()
    @skipToFirstError()
    @displayErrorsInTabs()

  skipToFirstError: ->
    @getErrorTabs().first().tab("show")

  displayErrorsInTabs: ->
    @getErrorTabs().each (i, e) =>
      $(e).addClass('error')

  getErrorTabs: ->
    $tabs = $()
    @errorTabs ||= @$form.find(".tab-pane .error").closest(".tab-pane").map (i, e) =>
      $e = $(e)
      @$tabs.find("[href='##{$e.attr("id")}']")

  updateGems: ->
    $.each @$gems, (i, e) =>
      @drawGems $(e)

    @$gems.on "change", (e) =>
      $select = $(e.currentTarget)
      @drawGems $select

  setupTabs: ->
    $('.nav-tabs a').click (e) ->
      e.preventDefault()
      $(e.currentTarget).tab('show')

  setupSelect2: ->
    self = @

    @$form.find("select").select2()

    @$form.on "cocoon:after-insert", (event, elt) =>
      elt.find("select")
      .on "change", ->
        self.drawGems($(@))
      .select2()

  drawGems: ($select) ->
    combination = $.map $select.find(":selected"), (e, i) =>
        @colors[$(e).attr("class")]
    .join("")

    sockets = window.App.SocketRenderer.renderFromString(combination)
    $select.closest(".gear").find(".sockets").html(sockets)

  @setup: ->
    new BuildForm().setup()

@App.BuildForm = BuildForm
