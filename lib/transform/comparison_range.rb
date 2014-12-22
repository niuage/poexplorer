module Transform
  class ComparisonRange
    attr_accessor :range

    delegate :first, :last, to: :range

    def initialize(operator, float)
      self.range = [nil, nil]

      case operator
      when ">"; range[0] = float
      when "<"; range[1] = float
      when "="; range[0] = range[1] = float
      else
        range[0] = float
      end
    end
  end
end
