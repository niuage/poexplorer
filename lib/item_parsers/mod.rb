module ItemParsers
  class Mod < Base
    # search_attributes :stats

    attr_accessor :parse_count # used to determine if explicit or implicit

    def initialize(search)
      super
      self.parse_count = 0
    end

    def recognize?(section)
      return false if search.skill?

      section.each do |line|
        puts line
        if ::Mod.find_by_item_mod(line)
          self.parse_count += 1
          return true
        end
      end
      puts ">>> not recognized"
      false
    end

    def update_search(section)
      self.section = section

      set_old_stats_as_implicit if parse_count == 2
      StatBuilder.new(search, nil, section, true).build
    end

    private

    def set_old_stats_as_implicit
      search.stats.first.try :update_attribute, :implicit, true
    end
  end
end
