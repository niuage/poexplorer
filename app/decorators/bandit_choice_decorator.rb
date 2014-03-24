class BanditChoiceDecorator < SimpleFormDecorator
  def bandit_choice(difficulty)
    form.input :"#{difficulty}_choice",
      label: "Deal with the bandits - #{difficulty}",
      collection: BanditChoice.choices(difficulty),
      selected: object.choice(difficulty)
  end

  def alternatives
    form.input :alternatives, input_options({
      label: "Any alternatives or advice?"
    }, {
      input: { class: "span12 medium-textarea" }
    })
  end
end
