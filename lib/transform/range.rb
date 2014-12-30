module Transform
  class Range
    attr_accessor :range

    delegate :first, :last, to: :range

    def initialize(lb, ub)
      self.range = [lb, ub]
    end
  end
end
