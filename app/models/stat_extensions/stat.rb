module StatExtensions
  module Stat
    extend ActiveSupport::Concern

    def elements
      "Lightning|Cold|Fire"
    end

    def elemental_damage?
      name.present? && !name.match(/^Adds.*(#{elements}) Damage$/i).nil?
    end

    def chaos_damage?
      name.present? && !name.match(/^Adds.*(Chaos) Damage$/i).nil?
    end

    def elemental_resistance
      name.try(:match, /^\+.*% to (#{elements}) Resistance$/i)
    end

    def chaos_resistance
      name.try(:match, /^\+.*% to (Chaos) Resistance$/i)
    end

    def all_resistance?
      name.try(:match, /^\+.*% to all Elemental Resistances$/i).present?
    end
  end
end
