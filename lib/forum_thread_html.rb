class ForumThreadHtml
  THREAD_ROOT = "http://www.pathofexile.com/forum/view-thread"
  SELECTORS = {
    last_edited_by: ".forumTable .content-container.first .last_edited_by",
    post_date: ".post_date",
    profile_link: ".profile-link",
    first_post: ".forumPostListTable tr:first-child .content",
    posted_by: ".forumPostListTable tr:first-child td:nth-child(2) .post_by_account a"
  }

  attr_accessor :thread_id

  def initialize(thread_id)
    @thread_id = thread_id
  end

  def thread
    @_thread ||= HtmlPage.new(url).html
  end

  def url
    self.class.url(thread_id)
  end

  def self.url(thread_id)
    [THREAD_ROOT, thread_id].join("/")
  end

  def items
    return unless (content = thread.css("script").last.content)
    matches = content.match(/new R\((.*)\)\)\.run\(\)/)
    return unless matches && matches.length > 1
    items = JSON.parse(matches[1])
    unique_items(items)
  end

  def unique_items(items)
    return nil unless (items.respond_to?(:each) && !items.empty?)
    unique_frame_type = Rarity.name_to_frame_type("Unique")
    items.select { |item| item[1]["frameType"] == unique_frame_type }
  end

  def thread_date
    last_edited_by = thread.css(SELECTORS[:last_edited_by]).first.try(:content)
    date = last_edited_by ?
      last_edited_by.match(/Last edited by.*on (.*)/i).try(:[], 1) :
      thread.css(SELECTORS[:post_date]).first.try(:content)
    DateTime.strptime(date, "%B %d, %Y %I:%M %p") if date
  end

  def prices
    PriceParser.new(thread)
  end

  def account
    thread.css(SELECTORS[:profile_link]).first.try :content
  end

  def first_post
    @_first_post ||= thread.css(SELECTORS[:first_post]).first.try(:inner_html)
  end

  def posted_by
    @_posted_by ||= thread.css(SELECTORS[:posted_by]).first.try :text
  end
end
