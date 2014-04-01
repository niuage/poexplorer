class OnlineStatus
  constructor: (root) ->
    @$root = $(root)
    @$onlineStatus = @$root.find(".online-status")

  setup: ->
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
          $account = self.$onlineStatus.find(".account[data-account='#{account}']")
          icon = $account.find("i")
          self.complete(icon)
          self.setOnlineStatus($account, icon, player)

        self.$onlineStatus.find("time").timeago()

  complete: (icon) ->
    icon.removeClass("icon-circle-blank").addClass("icon-circle")

  setOnlineStatus: ($account, icon, player) ->
    klass = if player.online then "online" else "offline"
    icon.addClass(klass)
    $onlineStatus = $account.parent()

    if player.online
      $onlineStatus
        .append(" &bull; <span class='ign'>IGN: <b>#{player.character}</b></span>")

      $onlineStatus.closest(".item").find(".send-pm").addClass("online-icon online")

    if player.last_online_iso8601
      $onlineStatus
        .append(" &bull; <time datetime='#{player.last_online_iso8601}'></time>")

  usernames: ->
    accounts = []
    $.each @$onlineStatus.find("span"), (i, elt) ->
      account = $(elt).html()
      if $.inArray(account, accounts) < 0
        accounts.push(account)
    accounts

  league: ->
    $("#search-form select.search_league").val()

  @setup: (root) ->
    new OnlineStatus(root).setup()

@App.OnlineStatus = OnlineStatus
