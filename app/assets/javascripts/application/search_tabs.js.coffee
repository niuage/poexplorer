$("body").on "submit", "#search-form", (e) ->
  e.preventDefault()
  $form = $(e.currentTarget)

  $.ajax
    url: $form.attr("action")
    data: $form.serialize()
    type: $form.attr("method")
    dataType: 'json'
    success: (data) ->
      console.log data.results
    error: ->
      ""
    complete: ->
      ""
