class SearchBuilder < Parslet::Transform
  rule(full_name_operator: simple(:name)) { search << name.to_s }
  rule(full_name_operator: { string: simple(:name) }) { search << name.to_s }

  rule(float_operator: {
    attribute: simple(:attribute),
    range: simple(:range)
  }) do
    search.range(attribute, range)
  end

  rule(float: simple(:value)) { value.to_f }

  rule(comparison_range: {
    comparison_operator: simple(:operator),
    float: simple(:float)
  }) do
    ::Transform::ComparisonRange.new(operator, float)
  end

  rule(range: { lb: simple(:lb), ub: simple(:ub) }) { lb..ub }

  rule(anything: simple(:name)) { search << name.to_s }

  rule(socket_count: simple(:socket_count)) { search.socket_count = socket_count.to_s }
  rule(linked_socket_count: simple(:socket_count)) { search.linked_socket_count = socket_count.to_s }

  rule(count: simple(:count)) { count }

  rule(price_operator: {
    range: simple(:range),
    currency: simple(:currency)
  }) do
    search.currency = Currency.normalize_name(currency)
    search.range(:price_value, range)
  end
end
