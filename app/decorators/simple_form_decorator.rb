class SimpleFormDecorator
  attr_accessor :form, :object

  delegate :input, :association, :fields_for, :button, to: :form

  def initialize(form)
    @form = form
    @object = form.object
  end

  protected

  def input_options(options = {}, html_options = {})
    input_options = html_options.delete(:input) || {}
    {
      wrapper_html: { class: width(html_options) },
      input_html: { class: "span12" }.merge(input_options)
    }.merge(options)
  end

  def width(options)
    return "" unless options[:width].present?
    "span" << options[:width].to_s
  end
end
