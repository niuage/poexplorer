class PlaystyleDecorator < SimpleFormDecorator
  def leagues
    form.input(:softcore, label: "Viable for Softcore") + \
    form.input(:hardcore, label: "Viable for Hardcore") + \
    form.input(:pvp, label: "Viable for PvP")
  end

  def klasses
    form.association :klasses, input_options(
      { label: "Playable classes", placeholder: "Can be played as..." },
      { input: { class: "" } }
    )
  end

  def video_url
    form.input :video_url, {
      label: "Youtube Video",
      as: :url,
      placeholder: "Show the build in action!"
    }
  end

  def life_type
    form.input :life_type, {
      collection: Build::LIFE_TYPES.to_a,
      include_blank: "N/A"
    }
  end
end
