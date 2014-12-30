class Currency
  DEFAULT = :alch

  class_attribute :rates

  self.rates = {
    alt: 1.to_f / 15,
    chrome: 1.to_f / 13,
    jew: 1.to_f / 8,
    chance: 1.to_f / 7.5,
    fus: 1.to_f / 2,
    alch: 1.to_f / 2.5,
    scour: 1.to_f / 2,
    chisel: 1.to_f / 3,
    vaal: 1.to_f / 1.5,
    chaos: 1,
    blessed: 1,
    regal: 2,
    gcp: 2,
    divine: 7.5,
    exa: 42.5,
    eternal: 80
  }

  attr_accessor :league_id, :value, :currency

  def initialize(value, currency, league_id)
    self.league_id = league_id
    self.value = value.to_f
    self.currency = currency
  end

  def self.orbs
    @_orbs ||= rates.keys
  end

  def orbs
    self.class.orbs
  end

  def rates
    self.class.rates
  end

  def to_chaos
    return nil unless valid?
    rates[currency] * value
  end

  def self.valid_currency?(currency)
    orbs.include?(currency.to_sym)
  end

  def valid?
    orbs.include?(currency) && value > 0
  end

  def currency=(currency)
    @currency = normalize_name(currency)
  end

  def normalize_name(name)
    return :chaos if name.to_s == "c"
    name.to_s.to_sym
  end
end
