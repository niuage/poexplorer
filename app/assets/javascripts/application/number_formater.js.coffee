class NumberFormatter
  constructor: ->
    @numbers = $(".facet .tag, .main-menu .tag span")

  setup: ->
    @numbers.html @formatNumber

  formatNumber: (i, oldHtml) =>
    @constructor.format(oldHtml)

  @format: (html) ->
    nb = parseInt(html)
    return nb if nb < 1000
    (nb / 1000).toFixed(1) + "k"

  onCountChange: ->
    $("body").on "countChanged", (e) =>
      $(".facet .tag, .main-menu .tag span").html(@formatNumber)

  @onCountChange: ->
    new NumberFormatter().onCountChange()

  @setup: ->
    new NumberFormatter().setup()

@App.NumberFormatter = NumberFormatter
