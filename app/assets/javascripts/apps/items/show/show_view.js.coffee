@HT.module "SoftwareApp.Show",
  (Show, HT, Backbone, Marionette, $, _) ->

    @Software = Marionette.ItemView.extend
      template: JST["templates/software/show/software"]

      events:
        "click #video-thumbnail": "createPlayer"

      createPlayer: ->
        $thumbnail = $("#video-thumbnail")
        spinner = new Spinner({
          lines: 13
          length: 0
          width: 12
          radius: 28
          color: "#8BF8F8"
          shadow: true
        }).spin($thumbnail.get(0))

        pop = Popcorn.smart(
          "#video-thumbnail",
          @model.get("video_url")
        )

        pop.on "playing", ->
          spinner.stop()
          $thumbnail.find("img").remove()

        pop.play()

      serializeData: ->
        @model.toViewAttributes()

    @FeaturedSoftware = Marionette.ItemView.extend
      className: "headerContent"
      template: JST["templates/software/featured/software"]
