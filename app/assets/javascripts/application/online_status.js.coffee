class OnlineStatus
  constructor: (root) ->
    @$root = $(root)
    @$onlineStatus = @$root.find(".online-status")

  accountStatuses: -> @updateAccountStatuses()

  createPlayers: (data) ->
    players = {}

    for player in data
      if !(players[player.account])
        players[player.account] = player
      else if !players[player.account].online && player.online
        players[player.account]["character"] = player.character
        players[player.account]["online"] = true

    players

  updateAccountStatuses: ->
    self = @
    $.ajax
      url: "/accounts"
      data:
        account: @accountNames()
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
    icon.removeClass("fa-circle-o").addClass("fa-circle")

  setOnlineStatus: ($account, icon, player) ->
    klass = if player.online then "online" else "offline"

    icon.addClass(klass)
    if player.online && !player.marked_as_online
      icon.removeClass("fa-circle").addClass("fa-check-circle")

    $onlineStatus = $account.parent()

    if player.online && player.character
      $onlineStatus
        .append(" &bull; <span class='ign'>IGN: <b>#{player.character}</b></span>")

      $onlineStatus.closest(".item").find(".send-pm").addClass("online-icon online")

    if player.last_online_iso8601
      $onlineStatus
        .append(" &bull; <time datetime='#{player.last_online_iso8601}'></time>")

  accountNames: ->
    accounts = []
    $.each @$onlineStatus.find("span"), (i, elt) ->
      account = $(elt).html()
      if $.inArray(account, accounts) < 0
        accounts.push(account)
    accounts

  league: ->
    $("#search-form select.search_league").val()

  @accountStatuses: (root) ->
    new OnlineStatus(root).accountStatuses()

@App.OnlineStatus = OnlineStatus
