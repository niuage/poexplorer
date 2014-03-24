class GearAndGemsFormDecorator < SimpleFormDecorator
  def gearing_advice
    form.input :gearing_advice, input_options({
      label: "General gearing advice"
      }, {
      input: { class: "span12 medium-textarea" }
    })
  end

  def uniques
    form.association :uniques, input_options(
      { label: "Select uniques required for the build", placeholder: "Uniques" },
      { input: { class: "" } }
    )
  end
end
