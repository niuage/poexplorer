module ItemExtensions
  module Price
    extend ActiveSupport::Concern

    included do
      store :price, accessors: [:price_value, :currency], coder: JSON

      attr_accessible :price
    end

    def price=(price_array)
      value, curr = price_array.to_a
      currency = Currency.new(value, curr, league_id)
      if currency.valid?
        self.price_value = currency.value
        self.currency = currency.currency
      else
        self.price_value = self.currency = nil
      end
    end

    def chaos_value
      Currency.new(price_value, currency, league_id).to_chaos
    end
  end
end
