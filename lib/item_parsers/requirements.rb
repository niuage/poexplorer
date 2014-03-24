module ItemParsers
  class Requirements < Base

    search_attributes :level, :str, :int, :dex

    def recognize?(section)
      section[0] == "Requirements:"
    end

    def level
      find_attribute_value "Level"
    end

    def dex
      find_attribute_value ["Dex", "Dex (gem)"]
    end

    def int
      find_attribute_value ["Int", "Int (gem)"]
    end

    def str
      find_attribute_value ["Str", "Str (gem)"]
    end
  end
end
