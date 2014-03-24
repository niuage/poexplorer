class Elastic::BaseSearch
  include Elastic::DSL::Base

  PAGINATES_PER = 15

  attr_accessor :context
  attr_reader :search, :order, :page, :per_page

  delegate :weapon?, :armour?, :misc?, :skill?, :map?, :has_sockets?, :unique?,
    :linked_socket_count, :elemental_damage, :evasion, :energy_shield, :armour,
    :level, :quality, :online?, :corrupted?, :item_type, :account,
    :order_by_mod_id, to: :search

  def initialize(search, options = {})
    @search = search
    @order = search.order.try(:to_sym) unless search.is_a?(Item)

    @page = (options[:page] || 1).to_i
    self.per_page = options[:per_page]

    @context = nil
  end

  def with_context(context, &block)
    old_context = self.context
    self.context = context
    yield
    self.context = old_context
  end

  def with_value(attr, &block)
    return unless (value = search.send(attr)).present?
    yield value
  end

  def find_all
    Tire::Search::Search.new { query { all } }.to_hash
  end

  def online_player_query
    { parent_type: 'player' }.update(
      Tire::Search::Search.new do
        query { boolean { must { term :online, true } } }
      end.to_hash
    )
  end

  def item?
    search.is_a?(Item)
  end

  def paginate
    context.from (page - 1) * per_page
    context.size per_page
  end

  def per_page=(per_page)
    per_page = per_page.to_i
    @per_page = per_page < 1 ? paginates_per : (per_page > 50 ? 50 : per_page)
  end

  def paginates_per
    PAGINATES_PER
  end
end
