class QueryParser < Parslet::Parser
  include ::Parser::Basics
  include ::Parser::Sockets
  include ::Parser::Math
  include ::Parser::Price
  include ::Parser::FullName
  include ::Parser::Dps
  include ::Parser::FixedParams

  rule(:any_operator) do
    full_name_operator |
    dps_operator |
    edps_operator |
    pdps_operator |
    price_operator |
    color_operator |
    socket_operator |
    is_operator
  end

  rule(:query) do
    space? >>
    (
      (
        any_operator |
        anything.as(:anything)
      ) >> space?).repeat >>
    space?
  end

  root(:query)
end
