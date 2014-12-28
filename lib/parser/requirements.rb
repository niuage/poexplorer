module Parser::Requirements
  extend ActiveSupport::Concern

  included do
    float_operator :str
    float_operator :int
    float_operator :dex

    rule(:level_operator) do
      str("level") | str("lvl") >>
      space? >>
      range_or_comp.as(:level_operator)
    end
  end
end
