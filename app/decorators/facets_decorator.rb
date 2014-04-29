class FacetsDecorator
  attr_accessor :params, :facets, :collection, :options

  delegate :each, to: :collection

  def self.decorate_collection(facets, params, options = {})
    self.new(facets, params, options)
  end

  def initialize(facets, params, options)
    self.facets = facets
    self.params = params
    self.options = options

    self.collection = facets.map do |facet_name, facet_data|
      FacetDecorator.new(
        facet_name,
        facet_data,
        params,
        no_facet_link
      )
    end
  end

  def no_facet_link
    options[:no_facet_link]
  end

  def params=(params)
    facet_params = params.dup
    facet_params.delete(:page)
    facet_params.delete(:layout)
    @params = facet_params
  end
end
