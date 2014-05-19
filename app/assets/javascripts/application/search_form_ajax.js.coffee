class AjaxForm
  constructor: ->
    @$results = $("#results")
    @$form = $("#search-form")
    @$submitButton = @$form.find("input[type=submit]")
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
          $.each data.results, (i, result) ->
            self.$results.append template(App.Item.create(result).toJson())

          self.$form.trigger(
            type: "itemLoaded",
            results: data.results
          )

        error: ->
          alert("An error occured. If the problem persists, contact niuage[at]gmail.com.")

        complete: ->
          self.$form.find("input[type=submit]").removeAttr("disabled")

    @$form.on "itemLoaded", (e) ->
      self.enhanceItems()

  enhanceItems: ->
    App.ItemRenderer.setup("#results .result")
    App.ItemVerification.setup({ root: "#results" })
    # App.OnlineStatus.accountStatuses("#results")
    App.PM.setup("#results")
    @$results.find("time").timeago()

  @setup: ->
    new AjaxForm()

@App.AjaxForm = AjaxForm
