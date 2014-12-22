class Elastic::BaseItemSearch < Elastic::BaseSearch
  include Elastic::Concerns::Sort
  include Elastic::Concerns::Facets

  delegate \
    :weapon?, :armour?, :misc?,
    :skill?,
    :map?,
    :has_sockets?,
    :unique?,
    :linked_socket_count,
    :elemental_damage,
    :evasion,
    :energy_shield,
    :armour,
    :level,
    :quality,
    :online?,
    :corrupted?,
    :item_type,
    :account,
    :order_by_mod_id,
    :generic_type?,
    :generic_type,
    :ngram_full_name,
    to: :search

  def initialize(search, options = {})
    @order = search.order.try(:to_sym) unless search.is_a?(Item)
    super
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
end
