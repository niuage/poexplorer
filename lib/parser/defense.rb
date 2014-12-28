module Parser::Defense
  extend ActiveSupport::Concern

  included do
    float_operator :armour
    custom_float_operator(:evasion) { str("eva") >> str("sion").maybe }
    custom_float_operator(:energy_shield) do
      str("es") | (str("energy").maybe >> space? >> str("shield"))
    end
    float_operator :block_chance
  end
end
