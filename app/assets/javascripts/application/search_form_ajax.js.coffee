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

    @setupPagination()

  setupEvents: ->
    self = @

    @$form.on "itemLoaded", (e) =>
      @updateFormAction(e.page)
      @updateURL(e.page)
      @enhanceItems(e)
      @updateTotalCount(e.page)
      @setPageNb(e.page.current)

    $("body").on "submit", "#search-form", (e) ->
      e.preventDefault()
      return false if self.working

      self.setPageNb(e.page)

      self.beforeSubmit()

      $.ajax
        url: self.$form.attr("action")
        data: self.$form.serialize()
        type: self.$form.attr("method")
        dataType: 'json'

        success: (data) ->
          page = data.page

          self.resetPageHtml()

          self.renderItems(data.results, data.page)
          self.renderFacets(data.facets)

          self.$form.trigger(
            type: "itemLoaded",
            results: data.results,
            page: data.page
          )

        error: ->
          alert("An error occured. If the problem persists, contact niuage[at]gmail.com.")

        complete: ->
          self.complete()

  resetPageHtml: ->
    @$results.html("")
    @$sidebar.html("")

  updateTotalCount: (page) ->
    @$innerHeader ||= $("#sub-header")
    @$innerHeader.find("span.tag span").text(
      App.NumberFormatter.format(page.results.totalCount)
    )

  updateFormAction: (page) ->
    @$form.attr
      action: page.formPath
      method: if page.persisted then "PUT" else "POST"

  setupFacets: ->
    @$sidebar.on "click", ".facet li a", (e) =>
      e.preventDefault()
      return if @working
      App.FacetHandler.click(e, @$form)

    @$sidebar.on "click", ".facet h3 a", (e) =>
      e.preventDefault()
      return if @working
      App.FacetHandler.reset(e, @$form)

  setupPagination: ->
    @$results.on "click", ".nav-link", (e) =>
      e.preventDefault()
      return if @working
      $a = $(e.currentTarget)
      page = $a.data("page")
      return unless page
      @$form.find("#search-page").val(page)
      @$form.trigger({ type: "submit", page: page })
      $('html, body').stop(true).animate(
        scrollTop: @$results.offset().top - 60,
        500
      )

  renderFacets: (facets) ->
    return if !facets || $.isEmptyObject(facets)

    $.each facets, (facetName, facet) =>
      @$sidebar.append @facetTemplate(App.Facet.create(facetName, facet).toJson())

  renderItems: (results, page) ->
    if results && results.length > 0
      layoutSize = @layoutSize()

      @renderPagination(page)

      $.each results, (i, result) =>
        @$results.append @resultTemplate(App.Item.create(result, layoutSize).toJson())

      @renderPagination(page)
    else
      @$results.append App.Item.templates["no-results"]()

  renderPagination: (page) ->
    nextPage = Math.min(page.current + 1, page.total)
    previousPage = Math.max(page.current - 1, 1)
    currentPage = page.current

    @$results.append(
      App.Item.templates["pagination"](
        nextPage: if currentPage < page.total then nextPage else null,
        previousPage: if currentPage > 1 then previousPage else null,
        currentPage: currentPage,
        totalCount: page.results.totalCount
      )
    )

  beforeSubmit: ->
    @working = true
    @$results.addClass("loading")
    @$sidebar.addClass("loading")
    @$submitButton.attr("disabled", "disabled")

  complete: ->
    @working = false
    @$results.removeClass("loading")
    @$sidebar.removeClass("loading")
    @$form.find("input[type=submit]").removeAttr("disabled")

    $nestedFields = @$form.find(".nested-fields")

    $removedStats = $nestedFields.find("[id$=_destroy][value=1]")
      .closest(".nested-fields")
    $removedStats.next("input").remove()
    $removedStats.remove()

  layoutSize: ->
    @$results.data("size")

  setPageNb: (nb) ->
    if nb = parseInt(nb)
      @$form.find("#search-page").val(nb)
    else
      @$form.find("#search-page").val("")

  updateURL: (page) ->
    History.pushState(
      page: page.current,
      page.title,
      page.path
    )

  enhanceItems: ->
    App.ItemRenderer.setup("#results .result")
    App.ItemVerification.setup({ root: "#results" })
    # App.OnlineStatus.accountStatuses("#results")
    App.PM.setup("#results")
    @$results.find("time").timeago()

  @setup: ->
    new AjaxForm()

@App.AjaxForm = AjaxForm
