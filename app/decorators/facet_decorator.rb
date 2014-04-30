class FacetDecorator
  NAMES = {
    rarity: "Rarity",
    linked_sockets: "Linked sockets",
    item_type: "Top 5 Types",
    name: "Top 5 Names",
    class: "Classes",
    unique: "Uniques"
  }

  attr_accessor :facet_name, :facet_data, :params, :term, :no_facet_link

  def initialize(facet_name, facet_data, params, no_facet_link)
    self.facet_name = facet_name
    self.facet_data = facet_data
    self.params = params
    self.no_facet_link = no_facet_link
  end

  def title
    NAMES[facet_name.to_sym]
  end

  def terms
    facet_data["terms"]
  end

  def term_title
    term["term"].to_s.titleize
  end

  def reset_path
    params.merge(:"#{facet_name}" => "")
  end

  def term_path
    params.merge(:"#{facet_name}" => term["term"])
  end

  def count_for_term
    term["count"]
  end

  def resetable?
    facet_link?
  end

  def show_reset?
    !no_facet_link && terms.length == 1
  end

  def facet_link?
    !no_facet_link
  end

  def with_term(term)
    old_term = self.term
    self.term = term
    yield
    self.term = old_term
  end

  def to_partial_path
    "searches/facet"
  end
end
