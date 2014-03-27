class SimilarSearchFormDecorator < SearchFormDecorator
  def similar?; true end

  def to_partial_path
    "items/similar_fields"
  end

  def stats_partial_path
    "similar_searches/stats/fields"
  end

  def minimum_mod_match(options = {})
    input(:minimum_mod_match,
          input_options({
            label: "<b>At least X <u>optional</u> mods<span id='optional-stat-count'></span> are matching</b>".html_safe,
          }, options)
    ).html_safe
  end

  def lower_mod_value
    button_checkbox :lte, {
      width: 4,
      message_checked: "Value is less or equal",
      message_unchecked: "Click for a lower or equal value"
    } do
      '<i class="icon-chevron-left"></i>'
    end
  end

  def higher_mod_value
    button_checkbox :gte, {
      width: 4,
      message_checked: "Value is greater or equal",
      message_unchecked: "Click for a greater or equal value"
    } do
      '<i class="icon-chevron-right"></i>'
    end
  end

  def required_mod
    button_checkbox :required, {
      width: 6,
      message_checked: "Click to make optional",
      message_unchecked: "Click to require this mod"
    } do
      '<i class="icon-ok"></i>'
    end
  end

  def excluded_mod
    button_checkbox :excluded, {
      width: 6,
      message_checked: "Click to make optional",
      message_unchecked: "Click to exclude this mod",
      data: {
        checked_class: "btn-danger",
        disable_inputs: true
      }
    } do
      '<i class="icon-minus-sign"></i>'
    end
  end

  def same_item_type(options = {})
    input :same_item_type, input_options({
      label: "Same item type only",
      input_html: { class: "" }
    }, options)
  end

  def has_price(options = {})
    input :has_price, input_options({
      label: "Must have a buyout price",
      input_html: { class: "" }
    }, options)
  end

  def item_types_select
    h.item_types_select(item_type_class)
  end

  # override
  def blank_order_option
    "Relevance"
  end

  def order_options
    method = :"#{search.archetype_name.downcase}_collection"

    ItemSorting.collection_to_array(ItemSorting::SIMILAR_SEARCH_ORDER).concat(
      ItemSorting.respond_to?(method) ? ItemSorting.send(method) : []
    )
  end

  private

  def item_type_class
    search.archetype_name.try(:constantize)
  end
end
