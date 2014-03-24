class OnlineStatus
  constructor: (root) ->
    @$root = $(root)
    @$account = @$root.find(".account")

  setup: ->
    @$account.click (e) -> e.preventDefault()
    @updateStatuses()

  createPlayers: (data) ->
    players = {}

    for player in data
      if !(players[player.account])
        players[player.account] = player
      else if !players[player.account].online && player.online
        players[player.account]["character"] = player.character
        players[player.account]["online"] = true

    players

  updateStatuses: ->
    self = @
    $.ajax
      url: "/players"
      data:
        account: @usernames()
        league: @league()
      dataType: "json"
      success: (data) ->
        players = self.createPlayers(data)

        for account, player of players
          $account = self.$root.find(".account[data-account='#{account}']")
          icon = $account.find("i")
          self.complete(icon)
          self.setOnlineStatus($account, icon, player)

  complete: (icon) ->
    icon.removeClass("icon-circle-blank").addClass("icon-circle")

  setOnlineStatus: ($account, icon, player) ->
    klass = if player.online then "online" else "offline"
    icon.addClass(klass)

    if player.online
      $account.find("span").html (i, old_html) ->
        old_html + " <span class='ign'>(IGN: #{player.character})</span>"

      $account.closest(".item").find(".send-pm").addClass("online-icon online")

  usernames: ->
    accounts = []
    $.each @$account.find("span"), (i, elt) ->
      account = $(elt).html()
      if $.inArray(account, accounts) < 0
        accounts.push(account)
    accounts

  league: ->
    $("#search-form select.search_league").val()

  @setup: (root) ->
    new OnlineStatus(root).setup()

@App.OnlineStatus = OnlineStatus
