class AjaxForm
  constructor: ->
    @$results = $("#results")
    @$form = $("#search-form")
    @$submitButton = @$form.find("input[type=submit]")
    @currentPage = 1
    @setupEvents()

  setupEvents: ->
    self = @
    source   = $("#result-template").html()
    template = Handlebars.compile(source)

    $("body").on "submit", "#search-form", (e) ->
      e.preventDefault()

      self.$submitButton.attr("disabled", "disabled")

      self.$results.html("")

      $.ajax
        url: self.$form.attr("action")
        data: self.$form.serialize()
        type: self.$form.attr("method")
        dataType: 'json'

        success: (data) ->
          if data.results && data.results.length > 0
            $.each data.results, (i, result) ->
              self.$results.append template(App.Item.create(result).toJson())
          else
            self.$results.append App.Item.templates["no-results"]()

          self.$form.trigger(
            type: "itemLoaded",
            results: data.results
          )

          self.updatePagination(data.pagination)

        error: ->
          alert("An error occured. If the problem persists, contact niuage[at]gmail.com.")

        complete: ->
          self.$form.find("input[type=submit]").removeAttr("disabled")

    @$form.on "itemLoaded", (e) ->
      self.enhanceItems()

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
