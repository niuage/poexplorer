class ForumThreadPage
  POE_URL = "http://www.pathofexile.com"
  FORUM_ROOT = "#{POE_URL}/forum/view-forum"

  CSS = {
    root_table: "#view_forum_table",
    thread_title: ".title a"
  }

  FORUM_IDS = [
    [415, 306],     # [SC selling, SC Shop],
    [418, 305],     # [HC selling, HC shop],
    [429, 427],     # [Anarchy selling, Anarchy Shop],
    [432, 430],     # [onsl selling, onsl shop]
    [429, 427],     # [domination selling, domination shop]
    [432, 430],     # [nemesis selling, nemesis shop]
    [508, 506],     # [ambush selling, ambush shop]
    [511, 509],     # [invasion selling, invasion shop]
    [511, 509]      # [2 week selling, 2 week shop]
  ]

  attr_accessor :league_id, :shop, :page_number

  def initialize(league_id, shop, page_number)
    self.league_id = league_id
    self.shop = shop
    self.page_number = page_number
  end

  def thread_ids
    page.css(CSS[:root_table]).css("tr")
      .map { |row| thread_id(row) }
      .compact
  end

  private

  def page
    @_page ||= HtmlPage.new(url).html
  end

  def thread_id(thread_row)
    link = thread_row.css(CSS[:thread_title]).first
    link.attr("href").match(/(\d+)/).try(:[], 1) if link
  end

  def forum_url
    "#{FORUM_ROOT}/#{FORUM_IDS[league_id - 1][shop]}"
  end

  def url
    "#{forum_url}/page/#{page_number}"
  end
end
