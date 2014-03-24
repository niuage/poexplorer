class BuildSearchFormDecorator < SimpleFormDecorator
  include ActionView::Helpers::FormOptionsHelper

  def keywords
    form.input :keywords, input_options({
      label: false,
      placeholder: "Keywords"
    }, { width: 4 })
  end

  def life_type
    form.input :life_type, input_options({
      collection: life_types_collection,
      label: false,
      include_blank: "Any life type"
    }, { width: 4 })
  end

  def klasses
    form.input :klass_ids, input_options({
      collection: klass_collection,
      placeholder: "Can be played as...",
      selected: object.klass_ids,
      label: false
    }, {
      input: { multiple: true, class: "" },
      width: 4
    })
  end

  def keystones
    form.input :keystone_ids, input_options({
      collection: keystone_collection,
      placeholder: "Any of these keystones",
      selected: object.keystone_ids,
      label: false
    }, {
      input: { multiple: true, class: "" },
      width: 4
    })
  end

  def skill_gems
    form.input :skill_gem_ids, input_options({
      as: :select,
      label: false
    }, { width: 4 }) do
      form.select :skill_gem_ids,
        options_for_select(skill_gem_collection, object.skill_gem_ids),
        {}, { multiple: true, class: "", placeholder: "Any of these gems" }
    end
  end

  def uniques
    form.input :unique_ids, input_options({
      collection: unique_collection,
      placeholder: "Uses any of these uniques",
      selected: object.unique_ids,
      label: false
    }, {
      input: { multiple: true, class: "" },
      width: 4
    })
  end

  def leagues
    form.input(:softcore) + \
    form.input(:hardcore) + \
    form.input(:pvp, label: "PvP")
  end

  def order
    form.input :order, input_options({
      label: false,
      include_blank: "Order by",
      collection: ['Date submitted', 'Rating']
    }, { width: 4 })
  end

  def user
    form.input :user_uid, input_options({
      as: :hidden
    })
  end

  private

  def life_types_collection
    Build::LIFE_TYPES.to_a
  end

  def skill_gem_collection
    SkillGem.select("id, name, attr").map { |g| [g.name, g.id, { class: g.attr }] }
  end

  def unique_collection
    Unique.select("id, name").map { |g| [g.name, g.id] }
  end

  def klass_collection
    Klass.select("id, name").map { |k| [k.name, k.id] }
  end

  def keystone_collection
    Keystone.select("id, name").map { |k| [k.name, k.id] }
  end

end
