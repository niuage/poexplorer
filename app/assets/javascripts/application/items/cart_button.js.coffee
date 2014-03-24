class CartButton
  constructor: (@buttons, @options) ->
    @itemIds = @options.itemIds
    @$buttons = $(@buttons)
    @$itemCount = $(".cart-item-count")

  setup: ->
    @events()
    @loadButtons()

  events: ->
    self = @

    $("#main-content").on "click", @buttons, (e) ->
      e.preventDefault()
      $button = $(@)

      self.disableButton($button)

      $.ajax
        url: $button.attr("href")
        type: $button.data("method")
        dataType: "json"
        success: $.proxy(self.success, self)
        error: $.proxy(self.error, self)
      false # why the fuck do I need that?

  loadButtons: ->
    self = @
    @$buttons.each (i, e) ->
      $button = $(e)
      id = $button.data("id")
      self.button($button)

  button: ($button) ->
    if @itemInCart($button)
      @removeFromCartButton($button)
    else
      @addToCartButton($button)

  itemInCart: ($button) ->
    $.inArray($button.data("itemId"), @itemIds) != -1

  disableButton: ($button) ->
    $button.addClass("disabled").data("disabled", "disabled").siblings(".tooltip").remove()
    $button

  enableButton: ($button) ->
    $button.removeClass("disabled").data("disabled", "").addClass("ttip")

  removeFromCartButton: ($button) ->
    @enableButton($button
      .attr("href", $button.data("remove"))
      .addClass("btn-danger")
      .removeClass("btn-success")
      .attr("title", $button.data("removeTitle"))
      .attr("data-original-title", $button.data("removeTitle"))
      .data("method", "delete")
      .data("inCart", true)
      .tooltip())

  addToCartButton: ($button) ->
    @enableButton($button
      .attr("href", $button.data("add"))
      .addClass("btn-success")
      .removeClass("btn-danger")
      .attr("title", $button.data("addTitle"))
      .attr("data-original-title", $button.data("addTitle"))
      .data("method", "post")
      .data("inCart", false)
      .tooltip())

  success: (data) ->
    if data.success
      $button = @findButtonById(data.item_id)
      return unless $button.length > 0
      @itemIds = data.item_ids
      @$itemCount.html(data.item_ids.length)
      @button($button)

  findButtonById: (id) ->
    @$buttons.filter("[data-item-id=#{id}]")

  error: ->
    alert("An error occurred. Refresh the page and try again later.")

  @setup: (buttons = "", options = {}) ->
    new CartButton(buttons, options).setup()

@App.CartButton = CartButton
