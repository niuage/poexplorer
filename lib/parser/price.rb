module Parser::Price
  extend ActiveSupport::Concern

  included do
    rule(:currency) do
      (
        str("chaos") | str("c") |
        str("alch") |
        str("gcp") |
        str("exa")
      )
    end

    rule(:price_operator) do
      (
        (float_range | comparison_range).as(:range) >> space? >>
        currency.as(:currency)
      ).as(:price_operator)
    end
  end
end
