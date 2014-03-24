class BuildFormDecorator < SimpleFormDecorator

  def save_button
    button :submit, save_button_label, class: "btn-success"
  end

  private

  def save_button_label
    object.published? ? "Save your build" : "Publish your build"
  end

end
