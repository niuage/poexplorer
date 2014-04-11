class VerifyButton
  constructor: (@$link) ->
    @unverifiedIcon = "fa fa-times"
    @verifiedIcon = "fa fa-check"
    @loadingIcon = "fa fa-refresh fa-spin"
    @$item = @$link.closest(".item")

  click: ->
    return unless @url()
    @startVerifyingProcess()
    @verify()

  verify: ->
    self = @
    $.ajax
      dataType: "json"
      type: "POST"
      url: @url()
      success: (data) ->
        self.success(data)
      error: ->
        self.error(self.url())
      complete: ->
        self.complete()

  startVerifyingProcess: ->
    @$link.addClass("disabled")
      .html("<i class='#{@loadingIcon}'></i>")

  url: ->
    @_url ||= @$link.attr("href")

  ###################### Ajax callbacks ######################

  success: (item) ->
    if item["verified"] then @itemVerified(item) else @itemSold()

    time = @$item.find("time")
    time.timeago("update", item["indexed_at"])

  error: (url) ->
    @$link
      .html("Failed...")
      .removeClass("btn-success")
      .addClass("btn-warning")

  complete: ->
    @$link.removeClass("disabled") unless @$link.is(".btn-danger")

  ################## After verification #####################

  itemVerified: (item = null) ->
    @verifyLink(item)

  itemSold: ->
    @unverifyLink()
    @slideUp()

  ##################### Links ############################

  slideUp: ->

  verifyLink: (item = null) ->
    @$link
      .addClass("verified btn-success")
      .removeClass("btn-warning")
      .html("Buy now!")
      .removeClass("verify").attr("target", "_blank")
    price = @$link.siblings(".price")
    if item && (orb = item["currency"]) && (price_value = item["price_value"])
      price.html("#{price_value} x <span class='orb #{orb}'>#{orb}</span>")
    else
      price.tooltip("destroy").remove()

    @$link
      .tooltip('hide')
      .unbind()
      .attr("href", @$item.find("h2 a, h1 a").attr("href"))

  unverifyLink: ->
    @$link
      .addClass("btn-danger disabled")
      .removeClass("btn-warning")
      .tooltip('hide')
      .unbind()
      .html("<i class='fa fa-times'></i> Sold")
      .siblings(".price")
      .remove()

@App.VerifyButton = VerifyButton
