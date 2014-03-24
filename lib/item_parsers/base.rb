module ItemParsers
  class Base
    SEARCH_TYPES = %w(search weapon armour misc)

    attr_accessor :search, :section

    class_attribute :_search_attributes,
                    :_weapon_attributes,
                    :_armour_attributes,
                    :_misc_attributes

    class InvalidSearchError < StandardError; end

    class << self
      # def self.search_attributes(*attributes)
      # def self.weapon_attributes(*attributes)
      # ...
      SEARCH_TYPES.each do |search_type|
        define_method("#{search_type}_attributes") do |*attributes|
          self.send("_#{search_type}_attributes=", attributes.presence || [])
        end
      end
    end

    # set defaults
    search_attributes
    weapon_attributes
    armour_attributes
    misc_attributes

    def find_property_name_from_attribute(attribute)
      property_mapping[attribute] || attribute.to_s.titleize.gsub("Per", "per")
    end

    def find_attribute_value(property_names)
      property_names = [property_names] unless property_names.respond_to?(:each)
      line = section.find { |line| property_name(line).in? property_names }

      return unless line
      value = line.split(":")[1].try(:strip)
      parse_value(value)
    end

    def recognize?(section)
      true
    end

    def initialize(search)
      self.search = search
    end

    def update_search(section)
      self.section = section

      update_search_attributes

      case
      when search.weapon?; update_weapon_attributes
      when search.armour?; update_armour_attributes
      when search.misc?  ; update_misc_attributes
      end
    end

    def self.define_property_value_getters
      # define defaults method to retrieve attributes values
      # based on the search/weapon/armour/misc attributes defined on the class

      (_search_attributes +
        _weapon_attributes +
        _armour_attributes +
        _misc_attributes).each do |attribute|

        define_method(attribute) do
          prop_name = find_property_name_from_attribute(attribute)
          find_attribute_value(prop_name)
        end
      end
    end

    protected

    def parse_value(value)
      return unless value
      case
      # x-y
      when (values = value.match(/((?:\+|-)(\d+))%/))
        values[1].to_i
      # +X% or -X%
      when (values = value.match(/(\d+)-(\d+)/))
        (values[1].to_f + values[2].to_f) / 2
      # int of float
      when (values = value.match(/([-+]?[0-9]*\.?[0-9]+)/))
        values[1]
      else
        value
      end
    end

    # def update_search_attributes
    # def update_weapon_attributes
    # ...
    SEARCH_TYPES.each do |search_type|
      define_method("update_#{search_type}_attributes") do
        self.send("#{search_type}_attributes").each do |attr|
          search.send("#{attr}=", self.send(attr)) unless search.send(attr).present?
        end
      end
    end

    def property_name(property)
      property.split(":")[0] if property
    end

    def property_in?(property, options)
      property_name(property).try(:in?, options)
    end

    # instance method returning the class attributes for a given type
    SEARCH_TYPES.each do |item_type|
      define_method("#{item_type}_attributes") do
        self.class.send("_#{item_type}_attributes") || []
      end
    end

    def property_mapping
      @mapping ||= {}
    end
  end
end
