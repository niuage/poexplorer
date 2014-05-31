class Currency
  ORBS = [:alch, :chaos, :gcp, :exa]
  DEFAULT = :alch

  def initialize(min, max, item_currency, league_id)
    @league_id = get_league_id(league_id)
    @min = min
    @max = max
    @item_currency = item_currency
    @prices = [
    {
      alch: {   alch: 1,  chaos: 1.0/2, gcp: 1.0/5, exa: 1.0/32 },
      chaos: {  alch: 2,  chaos: 1,     gcp: 1.0/2, exa: 1.0/20 },
      gcp: {    alch: 5,  chaos: 2,     gcp: 1,     exa: 1.0/7 },
      exa: {    alch: 32, chaos: 20,    gcp: 7,     exa: 1 }
    },
    {
      alch: {   alch: 1,  chaos: 1.0/2, gcp: 1.0/7, exa: 1.0/39 },
      chaos: {  alch: 2,  chaos: 1,     gcp: 1.0/4, exa: 1.0/34 },
      gcp: {    alch: 7,  chaos: 4,     gcp: 1,     exa: 1.0/10 },
      exa: {    alch: 39, chaos: 34,    gcp: 10,    exa: 1 }
    }
    ]
  end

  def range(in_currency)
    {}.tap do |range|
      range[:gte] = value(@min.to_f, in_currency) if @min.present?
      range[:lte] = value(@max.to_f, in_currency) if @max.present?
    end
  end

  def value(amount, in_currency)
    # 1 exa => ? gcp
    @prices[@league_id][@item_currency.to_sym][in_currency] * amount
  end

  def self.valid_currency?(currency)
    ORBS.include?(currency.to_sym)
  end

  def get_league_id(id)
    id.to_i % 2
  end

  def self.query_string
    "_exists_:price"
  end

  def self.sorting_script
    score = ORBS.map do |orb|
      "(doc['price.#{orb}'].empty ? 0 : (doc['price.#{orb}'].value * #{orb}_price))"
    end.join(" - ")
    "(#{score})"
  end
end
