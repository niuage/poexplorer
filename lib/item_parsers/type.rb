module ItemParsers
  class Type < Base
    search_attributes :rarity, :name, :base_name

    def recognize?(section)
      section[0].match("Rarity:")
    end

    def rarity
      rarity = Rarity.find_by(name: section[0].split(":")[1].try(:strip))
      rarity or raise(InvalidSearchError, "Rarity value is invalid")
    end

    def name
      section[1]
    end

    def base_name
      @base_name ||= section.last.try(:gsub, "Superior", "").try(:strip)
    end

    def item_type(section)
      return unless section
      self.section = section
      base_name = base_name()

      G_BASE_NAMES.each_pair do |categorie, types|
        types.each_pair do |type, base_names|
          if base_names.find { |bn| base_name.include?(bn) }
            type = type.classify
            return type if Item::TYPES.include?(type)
          end
        end
      end

      nil
    end

  end
end
