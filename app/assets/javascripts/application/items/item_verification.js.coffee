class ItemVerification
  constructor: (options) ->
    @$root = $(options.root)
    @unverifiedIcon = "fa fa-times"
    @verifiedIcon = "fa fa-check"
    @loadingIcon = "fa fa-refresh fa-spin"

  setup: ->
    @$root.on "click", ".reindex, .price", (e) ->
      e.preventDefault()
      $(@).closest(".item").find(".verify").click()

    @$root.on "click", ".item .verify", (e) =>
      self = @
      $link = $(e.currentTarget)
      url = $link.attr("href")
      e.preventDefault()
      return if url == "#"

      @startVerifyingProcess($link)
      $.ajax
        dataType: "json"
        type: "POST"
        url: url
        success: (data) ->
          self.success($link, data)
        error: ->
          self.error($link, url)

  verify: ($link, item = null) ->
    @verifyLink($link, item)
    @buyItem($link)

  sold: ($link) ->
    @unverifyLink($link)

  success: ($link, item) ->
    if item["verified"]
      @verify($link, item)
    else
      @sold($link)

    time = $link.closest(".item").find("time")
    time.timeago("update", item["indexed_at"])

  error: ($link, url) ->
    $link
      .html("Failed...")
      .removeClass("btn-success")
      .addClass("btn-warning")
      .attr("href", url) if $link.attr("href") == "#"

  startVerifyingProcess: ($link) ->
    $link.html("<i class='#{@loadingIcon}'></i>")
    $link.attr("href", "#")

  buyItem: ($link) ->
    $link
      .tooltip('hide')
      .unbind()
      .attr("href", $link.closest(".item").find("h2 a, h1 a").attr("href"))

  # Utilities

  verifyLink: ($link, item = null) ->
    $link
      .addClass("verified btn-success")
      .removeClass("btn-warning")
      .html("Buy now!")
      .removeClass("verify").attr("target", "_blank")
    price = $link.siblings(".price")
    if item && (orb = item["currency"]) && (price_value = item["price_value"])
      price.html("#{price_value} x <span class='orb #{orb}'>#{orb}</span>")
    else
      price.tooltip("destroy").remove()


  unverifyLink: ($link) ->
    $link
      .addClass("btn-danger disabled")
      .removeClass("btn-warning")
      .tooltip('hide')
      .unbind()
      .html("<i class='fa fa-times'></i> Sold")
      .siblings(".price")
        .remove()

  @setup: (options = {}) ->
    new @(options).setup()

@App.ItemVerification = ItemVerification
