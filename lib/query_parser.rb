class QueryParser < Parslet::Parser
  rule(:space) { match['\s\t'].repeat(1) }
  rule(:space?) { space.maybe }

  rule(:word) { match('\\w').repeat(1) }
  rule :string do
    str('"') >>
    ((str('\\') >> any) | (str('"').absent? >> any)).repeat.as(:string) >>
    str('"')
  end
  rule(:word_or_string) { word | string }
  rule(:anything) { match['^\s\t'].repeat(1) }

  rule(:digit) { match('\\d') }
  rule(:natural_number) { digit.repeat(1) }
  rule(:float) { (natural_number >> str(".").maybe >> natural_number.maybe).as(:float) }
  rule(:number_range) { number.as(:lb) >> str("..") >> number.as(:ub) }
  rule(:comparison_operator) { (str("<") | str(">") | str("=")) }

  rule(:float_range) { float.as(:lb) >> str("..") >> float.as(:ub) }

  rule(:socket_digit) { match['123456'] }

  rule(:full_name_operator) do
    str("name:") >>
    (word_or_string).as(:full_name_operator)
  end

  rule(:linked_sockets) { (socket_digit.as(:count) >> str("l")) }
  rule(:sockets) { socket_digit.as(:count) >> str("s") }

  def self.float_operator(attr)
    rule("#{attr}_operator".to_sym) do
      (
        (float_range | comparison_range).as(:range) >>
        space? >>
        str(attr.to_s).as(:attribute)
      ).as(:float_operator)
    end
  end

  rule(:comparison_range) do
    (
      comparison_operator.maybe.as(:comparison_operator) >>
      space? >>
      float.as(:float)
    ).as(:comparison_range)
  end

  float_operator :dps
  float_operator :edps
  float_operator :pdps

  rule(:currency) do
    (
      str("chaos") | str("c") |
      str("alch") |
      str("gcp") |
      str("exa")
    ) >> str("s").maybe
  end

  rule(:price_operator) do
    (
      comparison_range.as(:range) >> space? >>
      currency.as(:currency)
    ).as(:price_operator)
  end

  rule(:any_operator) do
    full_name_operator |
    dps_operator |
    edps_operator |
    pdps_operator |
    price_operator
  end

  rule(:query) do
    space? >>
    (
      (
        any_operator |
        sockets.as(:socket_count) | linked_sockets.as(:linked_socket_count) |
        anything.as(:anything)
      ) >> space?).repeat >>
    space?
  end

  root(:query)
end
