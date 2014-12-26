module SearchOperator
  class Has < SearchOperator::Base
    self.supported_operands = {
      bo: :bo,
      price: :bo,
      alt_art: :alt_art
    }

    def bo

    end

    def alt_art
  end
end
