module ItemExtensions
  module Price
    extend ActiveSupport::Concern

    included do
      store :price, accessors: [:alch, :chaos, :gcp, :exa, :price_value, :currency], coder: JSON

      attr_accessible :price, :alch, :chaos, :gcp, :exa, :price_value, :currency
    end

    def price=(price_array)
      price_array = price_array.to_a
      price_value = price_array[0]
      currency = price_array[1]
      if currency && Currency.valid_currency?(currency)
        self[:price] = { currency.to_sym => price_value.to_f }
      else
        self[:price] = nil
      end
    end

    def get_currency
      return nil if price.empty?
      curr = price.to_a[0].try(:[], 0).to_s
      Currency.valid_currency?(curr) ? curr : nil
    end

    def get_price_value
      return nil if price.empty?
      p = price.to_a[0].try(:[], 1).to_f
      p if p > 0
    end

  end
end
