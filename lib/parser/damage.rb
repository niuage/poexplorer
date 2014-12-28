module Parser::Damage
  extend ActiveSupport::Concern

  included do
    float_operator :dmg
    float_operator :pdmg
    float_operator :edmg

    float_operator :dps
    float_operator :edps
    float_operator :pdps

    float_operator :aps

    custom_float_operator(:csc) do
      (str("crit") >> str(" chance").maybe) | str("csc")
    end
  end
end
