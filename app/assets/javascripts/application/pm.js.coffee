class PM
  constructor: ->
    @setupPM()

  setupPM: ->
    $("#results").on "click", ".send-pm", (e) =>
      @sendPMForItem($(e.currentTarget).closest(".item"))

  sendPMForItem: ($item) ->
    name = $item.find("h2").text()

    $subject = $("<input>").attr("type", "text")
      .val("WTB #{name}")
      .attr("name", "subject")

    $content = $("<textarea>")
      .val(@pmContent($item))
      .attr("name", "content")

    $form = $("<form>")
      .attr("action", "http://www.pathofexile.com/private-messages/compose")
      .attr("target", "_blank")
      .attr("method", "post")
      .append($subject)
      .append($content)

    $form.appendTo("body")
    $form.submit()

    setTimeout(->
      $form.remove()
    , 500)

  pmContent: ($item) ->
    name = $item.find("h2").text()
    account = $item.find("a[data-account]").data("account")
    itemType = $item.data("itemType")
    $stats = $.map($item.find(".stats li"), (stat, i) ->
      $.trim($(stat).text())
    ).join("\n")

    """
Hey, #{account}!

I'd like to buy your #{name} (#{itemType}).

My IGN: [replace with your IGN]

Thanks!

[spoiler="Item Mods"]
#{$stats}
[/spoiler]

Found on PoExplorer.com
    """

  @setup: ->
    new PM()

@App.PM = PM
