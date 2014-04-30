class Vote
  constructor: ->
    @setup()

  setup: ->
    $("[data-vote=base]").on "click", "[data-vote=button]", (e) ->
      e.preventDefault()

      $button = $(e.currentTarget)
      return if $button.is(".voted")

      url = $button.data("url")

      $.ajax
        url: url
        type: "PUT"
        dataType: "json"
        success: (data) ->
          if (data.count)
            $base = $button.closest("[data-vote=base]")

            # $base.find(".vote-up, .vote-down").removeClass("voted")
            $button.addClass("voted")

            $base
              .find("[data-vote-count]")
              .html(data.count)

    # @loadVotes()

  loadVotes: (buildSelector = "") ->
    results = $(".signed_in .result[data-id], .signed_in .build-page[data-id]")
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
          $module = $(".result[data-id=#{v.id}] .vote-module, .build-page[data-id=#{v.id}] .vote-module")
          klass = if v.upvote then ".vote-up" else ".vote-down"
          $module.find(klass).addClass("voted")

  @setup: ->
    new Vote()

@App.Vote = Vote
