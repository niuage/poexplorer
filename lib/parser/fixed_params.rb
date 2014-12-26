module Parser::FixedParams
  extend ActiveSupport::Concern

  included do
    rule(:is_operator) do
      str("is:") >>
      (str("-").maybe.as(:exclude) >> word.as(:operand)).as(:is_operator)
    end
  end
end
