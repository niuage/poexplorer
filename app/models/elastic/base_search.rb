module Elastic
  class BaseSearch
    include Elastic::DSL::Base

    attr_accessor :context
    attr_reader :order, :page, :per_page
    attr_accessor :search

    def initialize(search, options)
      @search = search

      @page = (options[:page].presence || 1).to_i
      @page = 1 if @page < 1

      self.per_page = options[:per_page]

      @context = nil
    end

    def with_context(context, &block)
      old_context = self.context
      self.context = context
      yield
      self.context = old_context
    end

    def with_value(attr, &block)
      return unless (value = search.send(attr)).present?
      yield value
    end

    def find_all
      Tire::Search::Search.new { query { all } }.to_hash
    end

    def paginate
      context.from (page - 1) * per_page
      context.size per_page
    end

    def per_page=(per_page)
      per_page = per_page.to_i
      @per_page = per_page < 1 ? paginates_per : (per_page > 50 ? 50 : per_page)
    end

    def paginates_per
      15
    end
  end
end
