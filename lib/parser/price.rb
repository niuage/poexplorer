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
        range_or_comp >> space? >> currency.as(:currency)
      ).as(:price_operator)
    end
  end
end
