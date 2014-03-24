module StatExtensions
  module Stat
    extend ActiveSupport::Concern

    def elements
      "Lightning|Chaos|Cold|Fire"
    end

    def elemental_dps?
      name.present? && !name.match(/^Adds.*(#{elements}) Damage$/i).nil?
    end

    def resistance_element
      name.try(:match, /^\+.*% to (#{elements}) Resistance$/i)
    end

    def all_resistance?
      name.try(:match, /^\+.*% to all Elemental Resistances$/i).present?
    end
  end
end
