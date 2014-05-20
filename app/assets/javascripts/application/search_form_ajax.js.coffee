class AjaxForm
  constructor: ->
    @$results = $("#results")
    @$sidebar = $("#left-sidebar")
    @$form = $("#search-form")
    @$submitButton = @$form.find("input[type=submit]")

    @currentPage = 1

    resultTemplateHtml = $("#result-template").html()
    @resultTemplate = Handlebars.compile(resultTemplateHtml)

    facetTemplateHtml = $("#facet-template").html()
    @facetTemplate = Handlebars.compile(facetTemplateHtml)

    @setupEvents()

    @setupFacets()

  setupEvents: ->
    self = @

    $("body").on "submit", "#search-form", (e) ->
      e.preventDefault()

      self.beforeSubmit()

      $.ajax
        url: self.$form.attr("action")
        data: self.$form.serialize()
        type: self.$form.attr("method")
        dataType: 'json'

        success: (data) ->
          self.$results.html("")
          self.$sidebar.html("")
          layoutSize = self.layoutSize()

          self.renderItems(data.results)
          self.renderFacets(data.facets)

          self.$form.trigger(
            type: "itemLoaded",
            results: data.results
          )

          self.updatePagination(data.pagination)

        error: ->
          alert("An error occured. If the problem persists, contact niuage[at]gmail.com.")

        complete: ->
          self.complete()

    @$form.on "itemLoaded", (e) ->
      self.enhanceItems()

  setupFacets: ->
    @$sidebar.on "click", ".facet li a", (e) =>
      App.FacetHandler.click(e, @$form)

    @$sidebar.on "click", ".facet h3 a", (e) =>
      App.FacetHandler.reset(e, @$form)

  renderFacets: (facets) ->
    return if !facets || $.isEmptyObject(facets)

    $.each facets, (facetName, facet) =>
      @$sidebar.append @facetTemplate(App.Facet.create(facetName, facet).toJson())

  renderItems: (results) ->
    if results && results.length > 0
      $.each results, (i, result) =>
        @$results.append @resultTemplate(App.Item.create(result).toJson())
    else
      self.$results.append App.Item.templates["no-results"]()

  beforeSubmit: ->
    @$results.addClass("loading")
    @$sidebar.addClass("loading")
    @$submitButton.attr("disabled", "disabled")

  complete: ->
    @$results.removeClass("loading")
    @$sidebar.removeClass("loading")
    @$form.find("input[type=submit]").removeAttr("disabled")

  layoutSize: ->
    @$results.data("size")

  updatePagination: (pagination) ->
    @currentPage = pagination.currentPage

  enhanceItems: ->
    App.ItemRenderer.setup("#results .result")
    App.ItemVerification.setup({ root: "#results" })
    # App.OnlineStatus.accountStatuses("#results")
    App.PM.setup("#results")
    @$results.find("time").timeago()

  @setup: ->
    new AjaxForm()

@App.AjaxForm = AjaxForm
