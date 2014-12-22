# Used in the SearchBuilder.
# Basically allows to create a Search model
# from a FastSearch one.

class TireSearch
  attr_accessor :query, :search

  ATTR_MAPPING = {
    pdps: :physical_dps
  }

  def initialize(query)
    self.query = query.downcase.squish!
  end

  def to_search
    self.search = Search.new

    self.search.tap do |search|
      SearchBuilder.new.apply(parsed_query, search: self)
    end
  end

  def << value
    search.ngram_full_name ||= ""
    search.ngram_full_name << " #{value}"
  end

  # range can be a Range, or a ComparisonRange
  def range(attr, range)
    attr = get_attr(attr.to_sym)
    set(attr, range.first) if range.first
    set("max_#{attr}", range.last) if range.last
  end

  def method_missing(meth, *args, &block)
    if search.respond_to?(meth)
      search.send(meth, *args)
    else
      super
    end
  end

  private

  def parsed_query
    @parsed_query ||= QueryParser.new.parse(self.query)
  end

  def get_attr(attr)
    ATTR_MAPPING[attr].presence || attr
  end

  def set(attr, value)
    send("#{attr}=", value)
  end
end
