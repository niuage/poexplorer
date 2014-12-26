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
    ::Transform::ComparisonRange.new(operator, float)
  end

  rule(float_range: { lb: simple(:lb), ub: simple(:ub) }) { lb..ub }

  rule(anything: simple(:name)) { search << name.to_s }

  # sockets
  rule(count: simple(:count)) { count }
  rule(socket_count: simple(:socket_count)) do
    search.socket_count = socket_count.to_s
  end
  rule(linked_socket_count: simple(:socket_count)) do
    search.linked_socket_count = socket_count.to_s
  end

  # price
  rule(price_operator: {
    range: simple(:range),
    currency: simple(:currency)
  }) do
    search.currency = Currency.normalize_name(currency)
    search.range(:price_value, range)
  end

  # color
  rule(color_operator: { color: simple(:color) }) do
    search.socket_combination = color.to_s
  end

  # is operator
  rule(is_operator: { operand: simple(:operand), exclude: simple(:exclude) }) do
    SearchOperator::Is.new(operand, search: search, exclude: exclude ).call
  end
end
