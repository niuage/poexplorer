class BasicsFormDecorator < SimpleFormDecorator
  def title
    form.input :title, input_options({}, {
      input: { class: "span6" }
    })
  end

  def summary
    form.input :summary, input_options({
      label: "Summary (displayed in the listings)"
    })
  end

  def description
    form.input :description, input_options({}, {
      input: { value: object.description_value }
    })
  end

  def conclusion
    form.input :conclusion, input_options({}, {
      input: {
        value: object.conclusion_value,
        class: "span12 medium-textarea"
      }
    })
  end

end
