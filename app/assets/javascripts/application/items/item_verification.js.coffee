class ItemVerification
  constructor: (options) ->
    @$root = $(options.root)

  setup: ->
    @$root.on "click", ".item .price", (e) ->
      e.preventDefault()
      $(@).closest(".item").find(".verify").click()

    @$root.on "click", ".item .verify.disabled", (e) -> e.preventDefault()

    @$root.on "click", ".item .verify:not(.disabled)", (e) =>
      e.preventDefault()
      $link = $(e.currentTarget)

      new App.VerifyButton($link).click()

  @setup: (options = {}) ->
    new @(options).setup()

@App.ItemVerification = ItemVerification
