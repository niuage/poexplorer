class ModToggle
  constructor: ->
    @$form = $("#search-form")
    @onOptionalStatCountChange()

  # should be in another class
  onOptionalStatCountChange: ->
    if (@$statCount = @$form.find("#optional-stat-count")).length
      @updateOptionalStatCountOnToggle()
      @$form.trigger("optionalStatCountChanged")

  # should be in another class
  updateOptionalStatCountOnToggle: ->
    @$similarModMatchCount = @$form.find("#similar_search_minimum_mod_match")

    @$similarModMatchCount.on "change", (e) =>
      @$form.trigger("optionalStatCountChanged")

    @$form.on "cocoon:after-insert", (event, elt) =>
      @$form.trigger("optionalStatCountChanged")
    .on "cocoon:after-remove", "#stats", (event, elt) =>
      @$form.trigger("optionalStatCountChanged")
    .on "optionalStatCountChanged", (e) =>
      optionalStatCount = @optionalStatCount()

      @$statCount.html("out of #{optionalStatCount}")
      similarModMatchCount = parseInt(@$similarModMatchCount.val())
      @$statCount.removeClass()
      switch
        when similarModMatchCount > optionalStatCount
          @$statCount.addClass("life")
        when optionalStatCount - similarModMatchCount <= 1
          @$statCount.addClass("unique")
        else
          @$statCount.addClass("dex")

  # should be in another class
  optionalStatCount: ->
    $optionalMods = @$form.find(".optional-mods:visible")
    $optionalMods.length - $optionalMods.find(":checked").length

  # set the toggle buttons states
  # and setup their click event
  setupToggleButtons: ->
    @mirrorCheckboxState()

    @$form.on "click", ".btn-toggle", (e) =>
      @toggleMod($(e.currentTarget))
      false

    @$form.on "itemLoaded", (e) =>
      @mirrorCheckboxState()

  mirrorCheckboxState: ->
    @$form.find(".btn-toggle").each (i, e) =>
      $btn = $(e)
      $cb = @getCheckbox($btn)
      @setButton($btn, $cb.prop("checked"))

  getCheckbox: ($btn) ->
    $btn.siblings("[data-cbid=#{$btn.data("cbid")}]")

  toggleMod: ($btn) ->
    $cb = @getCheckbox($btn)
    checked = !$cb.prop("checked") # because we're going to change it
    $cb.prop("checked", checked)
    @setButton($btn, checked)
    $btn.tooltip("show")

    if $btn.parent(".toggle-group").length && checked
      # all siblings and exclude self?
      $btn.prevAll(".btn-toggle").each (i, e) => @setButton($(e), false)
      $btn.nextAll(".btn-toggle").each (i, e) => @setButton($(e), false)

    @$form.trigger("optionalStatCountChanged")

  messageChecked: ($btn) ->
    $btn.data("messageChecked")

  messageUnchecked: ($btn) ->
    $btn.data("messageUnchecked")

  message: ($btn) ->
    $cb = @getCheckbox($btn)
    if $cb.prop("checked") then @messagechecked($btn) else @messageUnchecked($btn)

  setButton: ($btn, checked) ->
    if checked
      [action1, icon, message, state] = ["addClass", "on", @messageChecked($btn), "disabled"]
    else
      [action1, icon, message, state] = ["removeClass", "off", @messageUnchecked($btn), ""]

    @getCheckbox($btn).prop("checked", checked)
    $btn[action1]("active #{@checked_class($btn)}")

    @switchIcons($btn, icon)

    $btn.closest(".controls-row").find(":text, [type=number]").prop("disabled", state) if $btn.is("[data-disable-inputs]")
    @toggleModTooltip($btn, message)

  switchIcons: ($btn, on_off) ->
    $icon = $btn.find("i")
    return unless (newIcon = $icon.data("fa-#{on_off}"))
    $icon.removeClass().addClass("fa #{newIcon}")

  checked_class: ($btn) ->
    $btn.data("checkedClass") || "btn-success"

  toggleModTooltip: ($btn, message) ->
    $btn.tooltip('destroy').attr("title", message).tooltip()

  setup: ->
    @setupToggleButtons()

    @$form.on "cocoon:after-insert", (event, elt) =>
      $btns = elt.find(".btn-toggle")
      $btns.each (i, btn) =>
        $btn = $(btn)
        @toggleModTooltip($btn, @message($btn))

  @setup: ->
    new ModToggle().setup()

@App.ModToggle = ModToggle
