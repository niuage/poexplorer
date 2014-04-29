class ExileSearchFormDecorator < SimpleFormDecorator
  include ActionView::Helpers::FormOptionsHelper

  def keywords
    form.input :keywords, input_options({
      label: false,
      placeholder: "Keywords"
    }, {
      width: 3
    })
  end

  def klasses
    form.input :klass_ids, input_options({
      collection: klass_collection,
      placeholder: "Filter by classes",
      selected: object.klass_ids,
      label: false
    }, {
      input: { multiple: true, class: "span12" },
      width: 3
    })
  end

  def uniques
    form.input :unique_ids, input_options({
      collection: unique_collection,
      placeholder: "Uses any of these uniques",
      selected: object.unique_ids,
      label: false
    }, {
      input: { multiple: true, class: "" },
      width: 5
    })
  end

  def unique_collection
    Unique.select("id, name").map { |g| [g.name, g.id] }
  end

  def klass_collection
    Klass.select("id, name").map { |k| [k.name, k.id] }
  end
end
