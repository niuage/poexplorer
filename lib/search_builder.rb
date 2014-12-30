class SearchBuilder < Parslet::Transform
  rule(full_name_operator: simple(:name)) { search << name.to_s }
  rule(full_name_operator: { string: simple(:name) }) { search << name.to_s }

  rule(float_operator: {
    attribute: simple(:attribute),
    range: simple(:range)
  }) do
    search.range(attribute, range)
  end

  rule(number: { sign: simple(:sign), natural: simple(:natural) }) do
    n = natural.to_s.to_i
    sign == "-" ? -n : n
  end

  rule(float: simple(:value)) { value.to_f }

  rule(comparison_range: {
    comparison_operator: simple(:operator),
    float: simple(:float)
  }) do
    a = ::Transform::ComparisonRange.new(operator, float)
  end

  rule(float_range: { lb: simple(:lb), ub: simple(:ub) }) do
    lb..ub
  end

  rule(anything: simple(:name)) { search << name.to_s }

  # sockets
  rule(count: simple(:count)) { count } # might not be used

  rule(socket_count_operator: simple(:range)) do
    search.range(:count, range)
  end
  rule(linked_socket_count_operator: simple(:range)) do
    search.range(:linked_socket_count, range)
  end

  # price
  rule(price_operator: {
    range: simple(:range),
    currency: simple(:currency)
  }) do
    range2 = ::Transform::Range.new(
      Currency.new(range.first, currency, search.league).to_chaos,
      Currency.new(range.last, currency, search.league).to_chaos
    )
    search.range(:chaos_value, range2)
  end

  # color
  rule(color_operator: { color: simple(:color) }) do
    search.socket_combination = color.to_s
  end

  # is operator
  rule(is_operator: { operand: simple(:operand), exclude: simple(:exclude) }) do
    SearchOperator::Is.new(operand, search: search, exclude: exclude ).call
  end

  # thread
  rule(thread_id: simple(:thread_id)) { search.thread_id = thread_id.to_s }

  # float operators
  rule(csc_operator: { range: simple(:range) }) { search.range(:csc, range) }
  rule(level_operator: { range: simple(:range) }) { search.range(:level, range) }
  rule(evasion_operator: { range: simple(:range) }) { search.range(:evasion, range) }
  rule(energy_shield_operator: { range: simple(:range) }) { search.range(:energy_shield, range) }
  rule(quality_operator: { range: simple(:range) }) { search.range(:quality, range) }

  # seller operator
  rule(seller_operator: simple(:seller)) { search.account = seller }
end
