class PoeApi
  LIMIT = 200

  include HTTParty
  base_uri "api.pathofexile.com"

  attr_reader :league

  def initialize(league)
    @league = league
  end

  def ladder(offset = 0, limit = LIMIT)
    response = self.class.get("/ladders/#{league}?offset=#{offset}&limit=#{limit}")
    yield response
  end
end
