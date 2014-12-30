class QueryParser < Parslet::Parser
  include ::Parser::Basics
  include ::Parser::Sockets
  include ::Parser::Math
  include ::Parser::Price
  include ::Parser::FullName
  include ::Parser::Damage
  include ::Parser::Defense
  include ::Parser::FixedParams
  include ::Parser::Requirements
  include ::Parser::Misc

  rule(:any_operator) do
    full_name_operator |
    dmg_operator | pdmg_operator | edmg_operator |
    dps_operator | edps_operator | pdps_operator |
    csc_operator |
    armour_operator | evasion_operator | energy_shield_operator | block_chance_operator |
    str_operator | dex_operator | int_operator | level_operator |
    quality_operator | thread_operator |
    price_operator |
    color_operator |
    socket_operator |
    is_operator |
    seller_operator
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
