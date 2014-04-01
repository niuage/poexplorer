require 'open-uri'

class ForumThreadHtml
  THREAD_ROOT = "http://www.pathofexile.com/forum/view-thread"
  SELECTORS = {
    last_edited_by: ".forumTable .content-container.first .last_edited_by",
    post_date: ".post_date",
    profile_link: ".profile-link"
  }

  attr_accessor :thread_id

  def initialize(thread_id)
    @thread_id = thread_id
  end

  def thread
    @_thread ||= Nokogiri::HTML(open(url))
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
    return unless matches.length > 1
    return JSON.parse(matches[1])
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
    thread.css(SELECTORS[:profile_link]).first.try :content if html
  end
end
