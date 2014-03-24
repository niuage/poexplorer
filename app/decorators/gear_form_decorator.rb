class GearFormDecorator < SimpleFormDecorator
  include ActionView::Helpers::FormOptionsHelper

  def name
    form.input :name, input_options({
      label: "Type of gear",
      collection: G_GEAR_TYPES,
      include_blank: "Any type"
    }, { width: 6, input: { class: "" } })
  end

  def description
    form.input :description, input_options({
      placeholder: "Describe this skill/piece of gear"
    }, { width: 6 })
  end

  def main
    form.input :main, label: "Main piece of gear. Its gems will be displayed in the listings."
  end

  def skill_gems
    gems = SkillGem.all.map { |g| [g.name, g.id, { class: g.attr }] }

    form.input :skill_gem_ids, input_options({
      as: :select,
      label: "Socketed gems"
    }) do
      form.select :skill_gem_ids,
        options_for_select(gems, object.skill_gem_ids),
        {}, { multiple: true, class: "gems-select" }
    end
  end
end
