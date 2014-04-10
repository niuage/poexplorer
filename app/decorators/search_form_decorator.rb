class SearchFormDecorator < ApplicationDecorator

  ############################
  #### REFACTOR THIS SHIT ####
  ############################

  attr_accessor :search, :form

  delegate :archetype_name, to: :search, allow_nil: true
  delegate :input, to: :form, allow_nil: true

  def initialize(search)
    @search = search
  end

  def with_form(new_form)
    old_form = self.form
    self.form = new_form
    yield self
    self.form = old_form
  end

  def submit(options = {})
    span(options) do
      form.submit "Search", class: "span12 btn btn-success"
    end
  end

  def item_name(options = {})
    input :name, input_options({}, options)
  end

  def item_type(options = {})
    input :item_type, input_options({
      as: :select
    }, options) do
      form.select :item_type,
        h.options_for_select(item_types_select, form.object.item_type),
        { include_blank: "Any type of #{search}" },
        class: "span12"
    end
  end

  def item_base_name(options = {})
    classes = "span12".tap do |classes|
      classes << " no-select2" unless similar?
    end

    input :base_name, input_options({
      collection: base_names_select,
      include_blank: "Any name",
      input_html: { class: classes },
      selected: form.object.base_name
    }, options)
  end

  #################

  def item_min_price(options = {})
    input :price_value, input_options({ as: :float }, options)
  end

  def item_max_price(options = {})
    input :max_price_value, input_options({ as: :float }, options)
  end

  def item_currency(options = {})
    input :currency, input_options({
      collection: Currency::ORBS,
      selected: form.object.currency || Currency::DEFAULT,
      input_html: { class: "span12 nh" }
    }, options)
  end

  #################

  def item_socket_count(options = {})
    max = options.delete(:max)
    method = max ? :max_socket_count : :socket_count
    input method, input_options({ as: :integer }, options)
  end

  def item_linked_socket_count(options = {})
    max = options.delete(:max)
    method = max ? :max_linked_socket_count : :linked_socket_count
    input method, input_options({ as: :integer }, options)
  end

  def item_socket_combination(options = {})
    input :socket_combination, input_options({}, options)
  end

  def item_league(options = {})
    input :league_id, input_options({
      collection: h.simple_options_for_select(League,
        text: ->(name) {
          return nil unless League.visible?(name)
          name.capitalize + " league"
        }),
      selected: form.object.league_id || current_league_id,
      input_html: { class: "span12 search_league" }
    }, options)
  end

  def item_rarity(options = {})
    input :rarity_id, input_options({
      collection: h.simple_options_for_select(Rarity),
      selected: form.object.rarity_id,
      include_blank: "Any rarity"
    }, options)
  end

  def only_corrupted(options = {})
    input :corrupted, input_options({
      label: "Only corrupted items",
      input_html: { class: "" }
    }, options)
  end

  #################

  def item_min_level(options)
    input :level, input_options({ as: :integer }, options)
  end

  def item_max_level(options)
    input :max_level, input_options({ as: :integer }, options)
  end

  #################

  def item_quality(options)
    input :quality, input_options({}, options)
  end

  #################

  def account(options)
    input :account, input_options({}, options)
  end

  def thread_id(options)
    input :thread_id, input_options({}, options)
  end

  #################

  def mods(options = {})
    options.reverse_merge!({ width: 6 })
    input :mod_id, input_options({
      as: :select
    }, options) do
      form.select :mod_id,
        h.grouped_options_for_select(mod_select, form.object.mod_id),
        { include_blank: "Mods" },
        class: "span12 no-select2"
    end
  end

  def stat_value(options = {})
    options.reverse_merge!({ width: 2 })
    input :value, input_options({}, options)
  end

  def stat_max_value
    input :max_value, input_options({}, { width: 2 })
  end

  # Stat requirements

  def stat_requirement(stat, options = {})
    input(stat, input_options({
    }, options)) + \

    input(:"max_#{stat}", input_options({
    }, options))
  end

  # end stats requirements

  def excluded
    button_checkbox(:excluded,
      message_checked: "Mod excluded. Click to require.",
      message_unchecked: "Mod required. Click to exclude.",
      data: { checked_class: "btn-danger" }
    ) do
      '<i class="fa fa-check" data-fa-on="fa-minus-circle" data-fa-off="fa-check"></i>'
    end
  end

  def link_to_remove_stat
    h.link_to_remove_association form, class: "btn span1", title: "Remove mod" do
      h.content_tag(:i, "", class: "fa fa-trash-o")
    end
  end

  def stats_partial_path
    "stats/fields"
  end

  # overriden in similar search
  def blank_order_option
    "Indexed at"
  end

  def online(options = {})
    input :online, input_options({
      label: "Online only <i class='fa fa-circle' style='color: green'></i>".html_safe,
      input_html: { class: "" }
    }, options)
  end

  def has_price(options = {})
    input :has_price, input_options({
      label: "Has a buyout price",
      input_html: { class: "" }
    }, options)
  end

  def order_by_mod_id
    return "" unless search.order_by_mod_id.to_i > 0

    h.link_to("#", class: "span3 inputy ttip",
      title: "Remove filter",
      data: { mod_sort: "remove" }) do
      "<i class='fa fa-times right'></i>Sorting by mod value".html_safe
    end + \
    h.content_tag(:p, class: "span1 inputy") do
      "then by"
    end
  end

  def order(options = {})
    order_by_mod_id.html_safe + \
    input(:order, input_options({
      collection: order_collection,
      include_blank: blank_order_option,
      input_html: { class: "span12", id: "order-select" },
      wrapper_html: {
        class: "#{width(options)} ttip",
        title: "Order by",
        data: { placement: "right" }
      }
    }, options))
  end

  def armour?; false end
  def weapon?; false end
  def misc?; false end
  def similar?; false end

  protected

  def input_options(options = {}, html_options = {})
    {
      label: false,
      wrapper_html: { class: width(html_options) },
      input_html: { class: "span12" }
    }.merge(options)
  end

  def span options, &block
    h.content_tag :span, class: width(options) do
      yield
    end
  end

  def width(options)
    "span" << options[:width].to_s
  end

  # most likely never called
  def item_types_select
    h.item_types_select
  end

  def mod_select
    @mod_select ||= h.mod_select(archetype_name)
  end

  def base_names_select
    h.base_names_select_for_category(archetype_name.constantize)
  end

  def order_options; [] end

  def order_collection
    order_options.concat(ItemSorting.default_collection)
  end

  def button_checkbox attribute, options = {}, &block
    classes = options.fetch(:class, [])
    width = options.fetch(:width, 1)
    checkbox_id = "cb-#{attribute}"

    h.link_to("#",
      class: ["span#{width}", "btn", "btn-toggle"].concat(classes),
      data: {
        cbid: checkbox_id,
        message_unchecked: options[:message_unchecked],
        message_checked: options[:message_checked]
      }.merge(options.fetch(:data, {}))
    ) do
      yield.html_safe
    end + \
    form.check_box(attribute, class: "hidden", data: { cbid: checkbox_id })
  end
end
