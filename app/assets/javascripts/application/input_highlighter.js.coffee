class InputHighlighter
  constructor: ->
    @$form = $("#search-form")

  highlightSelected: ->
    self = @
    $inputs = @$form.find("input[type=text], input[type=number], input[type=checkbox], select").filter(":not(.nh)")

    $inputs.each (i, e) ->
      self.highlight($(e))

    $inputs.on "change", ->
      self.highlight($(@), true)

    @$form.on "cocoon:after-insert", (event, $elt) =>
      $elt.find("select").on "change", ->
        self.highlight($(@))

  highlight: ($elt, decrement = false) ->
    if $elt.val() == "" || ($elt.is(":checkbox") && !$elt.is(":checked"))
      return if !decrement
      action =  "removeClass"
    else
      action = "addClass"

    # get the select2 elt instead of the real select
    if $elt.is("select") && (select2 = $elt.data("select2"))
      $elt = $("#" + select2.containerId + " > a")

    $elt[action]("highlight")

    @updateSectionCounter($elt)

  updateSectionCounter: ($elt) ->
    # get section name
    section = $elt.closest(".tabcontent")
    return if section.length == 0
    sectionName = "#" + section.attr("id").replace("-fields", "")

    # find tab
    $tab = section.closest(".search-tabs").find(".btn-group [href=#{sectionName}]")
    return if $tab.length == 0

    # find counter
    $counter = $tab.find(".counter")

    # or create counter
    if $counter.length == 0
      $counter = $("<span/>").addClass("tag counter").html("0")
      $tab.append($counter)

    # update counter
    $counter.html(section.find(".highlight").length)

  setup: ->
    @highlightSelected()

  @setup: ->
    new InputHighlighter().setup()

@App.InputHighlighter = InputHighlighter
