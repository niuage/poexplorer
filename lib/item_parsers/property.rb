module ItemParsers
  class Property < Base
    search_attributes   :quality

    misc_attributes   :level

    weapon_attributes :physical_damage,
                      :csc,
                      :elemental_damage,
                      :aps,
                      :armour,
                      :evasion,
                      :block_chance

    define_property_value_getters

    def recognize?(section)
      return true if recognize_property?(section)

      case
      when search.misc?  ; recognize_misc?(section)
      when search.weapon?; recognize_weapon?(section)
      when search.armour?; recognize_armour?(section)
      end
    end

    def level
      find_attribute_value(["Level", "Map Level"])
    end

    private

    def recognize_weapon?(section)
      section[0].gsub("Handed", "Hand").in?(titleized_weapon_types)
    end

    def recognize_armour?(section)
      section[0].in?(titleized_weapon_types)
    end

    def recognize_misc?(section)
      property_in?(section[0], ["Map Level"]) ||
        property_in?(section[1], ["Level"])
    end

    def recognize_property?(section)
      property_in?(section[0], ["Itemlevel"])
    end

    def titleized_weapon_types
      @_titleized_weapon_types ||= Weapon::TYPES.map(&:titleize)
    end

    def titleized_armour_types
      @_titleized_weapon_types ||= Armour::TYPES.map(&:titleize)
    end
  end
end
