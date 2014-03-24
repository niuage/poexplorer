class ModToggle
  constructor: ->
    @$form = $("#search-form")

  # set the toggle buttons states
  # and setup their click event
  setupToggleButtons: ->
    self = @

    @$form.find(".btn-toggle").each (i, e) ->
      $btn = $(e)
      $cb = self.getCheckbox($btn)
      self.setButton($btn, $cb.prop("checked"))

    @$form.on "click", ".btn-toggle", (e) ->
      self.toggleMod($(@))
      false

  getCheckbox: ($btn) ->
    $btn.siblings("[data-cbid=#{$btn.data("cbid")}]")

  toggleMod: ($btn) ->
    $cb = @getCheckbox($btn)
    checked = !$cb.prop("checked") # because we're going to change it
    $cb.prop("checked", checked)
    @setButton($btn, checked)
    $btn.tooltip("show")

    if $btn.parent(".toggle-group").length && checked
      $btn.prevAll(".btn-toggle").each (i, e) => @setButton($(e), false)
      $btn.nextAll(".btn-toggle").each (i, e) => @setButton($(e), false)

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
    return unless (newIcon = $icon.data("icon-#{on_off}"))
    $icon.removeClass().addClass(newIcon)

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
