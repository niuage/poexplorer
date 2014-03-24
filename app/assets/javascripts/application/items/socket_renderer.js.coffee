class SocketRenderer
  @render: ($item) ->
    @$sockets = $item.find(".sockets")
    sockets = @$sockets.data("sockets")
    return unless sockets

    @append @createSockets(sockets)

  @renderFromString: (stringCombination) ->
    sockets = []
    currentGroup = 0

    for socket in @clean(stringCombination)
      if socket == " "
        currentGroup += 1
      else
        sockets.push
          "group": currentGroup
          "attr": @socketColor(socket)

    @createSockets(sockets)

  @createSockets: (sockets) ->
    itemSockets = $()
    for socket, i in sockets
      itemSockets = itemSockets
        .add(@createSocket socket, i)
        .add(@createSocketLink sockets, socket, i)

  @createSocket: (socket, i) ->
    group = socket["group"]
    attr = socket["attr"]

    row = Math.floor(i / 2)
    posRight = ["left", "right"][row % 2]

    $("<div>").addClass("socket socket-#{attr} socket-#{posRight}")

  @createSocketLink: (sockets, socket, i) ->
    currentGroup = socket["group"]
    nextGroup = (sockets[i + 1] && sockets[i + 1]["group"])
    return if nextGroup == undefined
    if currentGroup == nextGroup
      $("<div>").addClass("socket-link socket-link-#{i}")

  @clean: (string) ->
    string.replace(/[^rgbw\s]/ig, "").replace(/\s+/g, " ").replace(/^\s\s*/, '').replace(/\s\s*$/, '')

  @append: ($sockets) ->
    @$sockets.append $sockets

  @socketColor: (socketLetter) ->
    { r: "S", g: "D", b: "I", w: "G" }[socketLetter.toLowerCase()]

@App.SocketRenderer = SocketRenderer
