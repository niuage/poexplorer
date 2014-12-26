module SearchOperator
  class Is < SearchOperator::Base
    self.supported_operands = {
      online: :online,
      corrupted: :corrupted
    }

    def call
      send(action) if action
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
