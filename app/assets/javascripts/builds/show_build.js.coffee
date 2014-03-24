class BuildPage
  constructor: ->
    @colors = { int: "b", str: "r", dex: "g", gen: "w" }

  setup: ->
    @drawGems()

  drawGems: ->
    $(".skill-gems").each (i, e) =>
      $gems = $(e)
      combination = $.map $gems.find("li"), (e, i) =>
          @colors[$(e).data("attr")]
      .join("")

      sockets = window.App.SocketRenderer.renderFromString(combination)
      $gems.closest(".gear").find(".sockets").html(sockets)

  @setup: ->
    new BuildPage().setup()


@App.BuildPage = BuildPage
