class SearchForm
  constructor: ->
    @$form = $("#search-form")
    @$stats = @$form.find("#stats")
    @$type = @$form.find("#item-type-select")
    @$name = @$form.find("#base-name-select")

    @selectedType = null

  events: ->
    self = @

    @$form.find("select:not(.no-select2)").select2()

    @$form.on "cocoon:after-insert", (event, $elt) =>
      $elt.find("select").select2
        matcher: $.proxy(@typeMatcher, @)

    @socketPreview()

    @onTypeChange()

  socketPreview: ->
    $field = $(["#weapon_search_socket_combination",
      "#armour_search_socket_combination"].join(","))

    socketHelpMessage = "<p class='small text'><span class='tag tag-red'>R</span>, <span class='tag tag-green'>G</span>, <span class='tag tag-blue'>B</span>, <span class='tag tag-light-grey'>W</span> represent the 4 socket types. Use spaces to create groups of linked sockets.<br/>Ex: GGRR GR</p>"

    $field.on "keyup", ->
      sockets = App.SocketRenderer.renderFromString($field.val())
      popup = $field.data("popover")
      popup.setContent()
      popup.$tip.addClass(popup.options.placement)
      popup.applyPlacement()

    $field.popover
      content: ->
        sockets = App.SocketRenderer.renderFromString($field.val())
        $sockets = $("<div>").addClass("sockets w-2 h-3")
        if sockets.length
          $sockets.append sockets
        else
          $sockets.append(socketHelpMessage)
      title: "Sockets preview"
      animation: true
      placement: "left"
      html: true
      trigger: "focus"

  typeMatcher: (term, text, $opt) ->
    textMatch = text.toUpperCase().indexOf(term.toUpperCase()) >= 0
    return textMatch if !@selectedType
    !$opt.attr("value") || (textMatch && $opt.hasClass(@selectedType))

  onTypeChange: ->
    @$type.on "change", =>
      $selectedOption = @$type.find(":selected")
      @selectedType = $selectedOption.data("type")

    @$form.on "itemLoaded", (e) =>
      @$stats.find("select").select2
        matcher: $.proxy(@typeMatcher, @)

    @$type.trigger "change"

    @$name.select2
      matcher: $.proxy(@typeMatcher, @)

    @$form.find("#stats select").select2
      matcher: $.proxy(@typeMatcher, @)

  setup: ->
    @events()
    @

  @setup: ->
    new @().setup()

@App.SearchForm = SearchForm
