module SearchOperator
  class Is < SearchOperator::Base
    self.supported_operands = {
      online: :online,
      corrupted: :corrupted,
      priced: :priced
    }

    def call
      send(action) if action
    end

    def priced
      search.has_price = on
    end

    def online
      search.online = on
    end

    def corrupted
      corrupted_int = on ? 1 : -1
      search.corrupted = corrupted_int
    end
  end
end
