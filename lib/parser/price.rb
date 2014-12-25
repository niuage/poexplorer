module Parser::Price
  extend ActiveSupport::Concern

  included do
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
  end
end
