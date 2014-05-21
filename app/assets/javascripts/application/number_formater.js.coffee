class NumberFormatter
  constructor: ->
    @numbers = $(".facet .tag, .main-menu .tag span")

  setup: ->
    @numbers.html @format

  format: (i, oldHtml) =>
    @constructor.format(oldHtml)

  @format: (html) ->
    nb = parseInt(html)
    return nb if nb < 1000
    (nb / 1000).toFixed(1) + "k"

  @setup: ->
    new NumberFormatter().setup()

@App.NumberFormatter = NumberFormatter
