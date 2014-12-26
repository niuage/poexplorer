module SearchOperator
  class Base
    attr_accessor :operand, :search, :on
    class_attribute :supported_operands

    def initialize(operand, options)
      self.operand = operand
      self.search = options[:search]
      self.on = !(options[:exclude] == "-")
    end

    def action
      @_action ||= supported_operands[operand.to_s.to_sym]
    end
  end
end
