module Parser::Dps
  extend ActiveSupport::Concern

  included do
    float_operator :dps
    float_operator :edps
    float_operator :pdps
  end
end
