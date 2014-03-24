class NumberFormatter
  constructor: ->
    @numbers = $(".facet .tag, .main-menu .tag")

  setup: ->
    @numbers.html @format

  format: (i, oldHtml) ->
    nb = parseInt(oldHtml)
    return nb if nb < 1000
    (nb / 1000).toFixed(1) + "k"

  @setup: ->
    new NumberFormatter().setup()

@App.NumberFormatter = NumberFormatter
