module GearHelper
  def gear_input(f, type, collection)
    f.input type,
      collection: collection,
      input_html: { class: "span12" },
      wrapper_html: { class: "clearfix" },
      label: false,
      as: :select,
      placeholder: type.to_s.titleize
  end

  # def collection_for_type(type, collection)
  #   Rails.cache.fetch("collection_for_#{type}") do
  #     collection
  #   end
  # end
end
