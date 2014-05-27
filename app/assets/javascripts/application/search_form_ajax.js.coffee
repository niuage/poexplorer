class AjaxForm
  constructor: (@modelName) ->
    @$results = $("#results")
    @$sidebar = $("#left-sidebar")
    @$form = $("#search-form")
    @$submitButton = @$form.find("input[type=submit]")
    @$stats = @$form.find("#stats")
    @$body = $("body")

    # templates
    @resultTemplate = Handlebars.templates.item
    @facetTemplate = Handlebars.templates.facet
    @statTemplate = Handlebars.templates.stat

    @setupEvents()

    @setupFacets()

    @setupPagination()

  setupEvents: ->
    self = @

    @modHandling()

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
          self.renderForm(data.stats)

          self.$form.trigger(
            type: "itemLoaded",
            results: data.results,
            page: data.page
          )

        error: ->
          self.$results.find(".no-results").remove()
          self.$results.prepend(
            $('<div class="no-results">').html("<p>An error occured. If the problem persists, contact niuage[at]gmail.com.</p>")
          )

        complete: ->
          self.complete()

  resetPageHtml: ->
    @$results.html("")
    @$sidebar.html("")
    @$stats.find(".nested-fields").remove()
    @$stats.find("input").remove()

  updateTotalCount: (page) ->
    @$innerHeader ||= $("#sub-header")
    @$innerHeader.find("span.tag span").text(page.results.totalCount)
    $("body").trigger('countChanged')

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
      @$results.append Handlebars.templates.no_results()

  renderForm: (stats) ->
    @$stats.html("")
    $.each stats, (i, stat) =>
      @$stats
        .append(@statTemplate(stat))
        .find("select[data-pos='#{stat.order}']")
        .val(stat.mod_id)

  renderPagination: (page) ->
    nextPage = Math.min(page.current + 1, page.total)
    previousPage = Math.max(page.current - 1, 1)
    currentPage = page.current

    @$results.append(
      Handlebars.templates.pagination(
        nextPage: if currentPage < page.total then nextPage else null,
        previousPage: if currentPage > 1 then previousPage else null,
        currentPage: currentPage,
        totalPageCount: page.total,
        totalCount: page.results.totalCount
      )
    )

  beforeSubmit: ->
    @working = true
    @$results.addClass("loading")
    @$sidebar.addClass("loading")
    @$body.addClass("loading")
    @$submitButton.attr("disabled", "disabled")

  complete: ->
    @working = false
    @$results.removeClass("loading")
    @$sidebar.removeClass("loading")
    @$body.removeClass("loading")
    @$form.find("input[type=submit]").removeAttr("disabled")

    $nestedFields = @$form.find(".nested-fields")

    $removedStats = $nestedFields.find("[id$=_destroy][value=1]")
      .closest(".nested-fields")
    $removedStats.next("input").remove()
    $removedStats.remove()

  modHandling: ->
    @$form.on "click", "[data-remove]", (e) =>
      e.preventDefault()
      return if @working

      $remove = $(e.currentTarget)
      $fields = $remove.closest(".nested-fields")
      if $remove.data("remove") # hides and set _destroy to 1
        $remove.prev("input[type=hidden]").val("1")
        $fields.slideUp()
      else # the stat can just be removed now
        $fields.next("input[type=hidden]").remove()
        $fields.remove()
      @$form.trigger('cocoon:after-remove', [$fields])

    @$form.on "click", "#add-mod", (e) =>
      return if @working
      e.preventDefault()
      order = new Date().getTime()

      new_stat = { order: order }
      new_stat[@modelName] = true

      @$stats.append @statTemplate(new_stat)
      @$form.trigger('cocoon:after-insert', [@$stats.find("#mod_#{order}")])

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

  @setup: (modelName = "") ->
    new AjaxForm(modelName)

@App.AjaxForm = AjaxForm
