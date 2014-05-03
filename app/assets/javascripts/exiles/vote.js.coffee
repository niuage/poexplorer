class Vote
  constructor: ->
    @setup()

  setup: ->
    $("[data-vote=base]").on "click", "[data-vote=button]", (e) ->
      e.preventDefault()

      $button = $(e.currentTarget)
      return if $button.is(".voted")

      url = $button.data("url")

      if $button.is("[data-login=true]")
        window.location = url
        return

      $base = $button.closest("[data-vote=base]")
      $buttons = $base.find("[data-vote=button]")

      $buttons.find(".fa-caret-up")
        .removeClass("fa-caret-up")
        .addClass("fa-spin fa-spinner")

      $.ajax
        url: url
        type: "PUT"
        dataType: "json"
        success: (data) ->
          if (data.count)
            $buttons.addClass("voted").end()
              .find("[data-vote-count]").html(data.count)
        complete: ->
          $buttons.find(".fa-spin")
            .removeClass("fa-spin fa-spinner")
            .addClass("fa-caret-up")

    @loadVotes()

  loadVotes: (buildSelector = "") ->
    results = $(".signed_in .result[data-id], .signed_in [data-model=base][data-id]")
    return if results.length == 0

    ids = $.map results, (e, i) ->
      parseInt($(e).data("id"))

    $.ajax
      url: "/exiles/load_votes"
      data:
        ids: ids
      type: "POST"
      dataType: "json"
      success: (data) ->
        return unless (votes = data.votes)
        $.each votes, (i, v) ->
          $module = $(".result[data-id=#{v.id}]")
          $module = $(".c-exiles.a-show [data-vote=base]") unless $module.length
          $module.find("[data-vote=button]").addClass("voted")

  @setup: ->
    new Vote()

@App.Vote = Vote
