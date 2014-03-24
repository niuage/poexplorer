class SkillTreeDecorator < SimpleFormDecorator
  def url
    form.input :url, input_options({
      as: :url
    }, { width: 9 })
  end

  def level
    form.input :level, input_options({}, {
      width: 3
    })
  end

  def description
    form.input :description, input_options()
  end

end
