class ItemParser
  attr_accessor :search, :text, :sections

  PARSERS = [
    ItemParsers::Type,
    ItemParsers::Requirements,
    ItemParsers::Sockets,
    ItemParsers::Property,
    ItemParsers::Mod,
    ItemParsers::Base
  ]

  def initialize(text)
    self.text = text || ""
    self.search = create_search

    parse_sections
  end

  def parse_sections
    sections.each { |section| section_parser(section).update_search(section) }
    search.save
  end

  private

  def section_parser(section)
    parser = parsers.find { |parser| parser.recognize?(section) }
  end

  def parsers
    @parsers ||= PARSERS.map do |parser_class|
      parser_class.new(self.search)
    end
  end

  def create_search
    type_section = sections[0]
    parser = ItemParsers::Type.new(nil)
    item_type = parser.item_type(type_section)
    raise TypeError, "This item doesn't seem to be valid" unless item_type
    SimilarSearch.new(item_type: item_type).tap do |search|
      search.force_minimum_mod_match = true
    end
  end

  def text=(text)
    self.sections = \
      text.split("--------")
        .map! do |s|
          new_line = "\n".tap do |separator|
            separator.insert(0, "\r") if s.match(/\r/)
          end
          s.split(new_line)
        end
        .map! { |s| s.delete_if &:empty? }
        .map! { |s| s }
  end
end
