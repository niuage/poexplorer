module Parser::Math
  extend ActiveSupport::Concern

  included do
    rule(:digit) { match('\\d') }

    rule(:natural_number) { digit.repeat(1) }

    rule(:number) do
      (
        (str("+") | str("-")).maybe.as(:sign) >>
        natural_number.as(:natural)
      ).as(:number)
    end

    rule(:number_range) { number.as(:lb) >> str("..") >> number.as(:ub) }

    rule(:float) { (natural_number >> (str(".") >> natural_number).maybe).as(:float) }
    rule(:float_range) { (float.as(:lb) >> str("..") >> float.as(:ub)).as(:float_range) }

    rule(:comparison_operator) { (str("<") | str(">") | str("=")) }
  end
end
