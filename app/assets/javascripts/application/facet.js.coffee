class Facet
  constructor: (@facetName, @facet) ->

  names:
    rarity: "Rarity",
    linked_sockets: "Linked sockets",
    item_type: "Top 5 Types",
    name: "Top 5 Names",
    class: "Classes",
    unique: "Uniques"

  toJson: ->
    name: @facetName
    title: @title()
    terms: @terms()
    resetable: true
    reset_on: "reset-on" if @terms().length == 1

  terms: ->
    @_terms ||= $.map @facet.terms, (facet, i) =>
      title: facet.term
      count: facet.count

  title: ->
    @names[@facetName]

  @create: (facetName, facet) ->
    new Facet(facetName, facet)

@App.Facet = Facet
