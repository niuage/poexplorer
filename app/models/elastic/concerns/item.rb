module Elastic::Concerns::Item
  extend ActiveSupport::Concern

  def must_have_sockets
    return unless search.has_sockets?
    must_be_between(:socket_count)
    must_be_between(:linked_socket_count)

    unless search.socket_combination.blank?
      search_socket_combination = SocketCollection.search_combination(
        search.socket_combination
      )
      context.must do
        # TODO the cleaning up should be done when saving the search socket combination, maybe
        string "socket_combination:#{search_socket_combination}",
          default_operator: "AND"
      end
    end
  end

  def filter_armour_requirements
    [:evasion, :energy_shield, :armour, :block_chance].each do |stat|
      filter_between stat
    end
  end

  def must_have_stats
    search.stats.each do |stat|
      next unless stat.mod_id.present?

      stats_match stat, stat.excluded? do |c|
        c.must { term :mod_id, stat.mod_id }

        range_options = {}.tap do |range|
          range[:gte] = stat.value if stat.value
          range[:lte] = stat.max_value if stat.max_value
        end

        if !stat.excluded? && !range_options.empty?
          c.must { range :value, range_options }
          # the should was here to make searches successful
          # if the user entered a value for a mod that doesnt have one
          # c.should { string "_missing_:value" }
        end
      end

    end
  end

  def must_have_price
    if search.currency.present? && (search.price_value.present? || search.max_price_value.present?)
      currency = Currency.new(search.price_value, search.max_price_value, search.currency, search.league_id.to_i)
      context.must do
        boolean minimum_number_should_match: 1 do
          Currency::ORBS.each do |currency_name|
            should { range "price.#{currency_name}", currency.range(currency_name) }
          end
        end
      end
    elsif search.has_price? || search.order == "price"
      context.must { string Currency.query_string }
    end
  end

  private

  def stats_match(stat, excluded)
    options = { action: excluded ? :must_not : :must }
    # options.merge!(minimum_number_should_match: 1) unless excluded

    context.send(options.delete(:action)) do
      nested path: 'stats' do
        query do
          boolean(options) do
            yield self
          end
        end
      end
    end
  end
end
