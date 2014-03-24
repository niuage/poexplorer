class Scrawler < Indexer
  FORUM_IDS = [
    [415, 306],     # [SC selling, SC Shop],
    [418, 305],     # [HC selling, HC shop],
    [429, 427],     # [Anarchy selling, Anarchy Shop],
    [432, 430],     # [onsl selling, onsl shop]
    [429, 427],     # [domination selling, domination shop]
    [432, 430],      # [nemesis selling, nemesis shop]
    [508, 506],     # [ambush selling, ambush shop]
    [511, 509]      # [invasion selling, invasion shop]
  ]

  attr_accessor :scrawl, :forum_url

  def initialize(league = 0, shop = 0)
    @forum_url = "#{FORUM_ROOT}/#{FORUM_IDS[league][shop]}"
  end

  def scrawl!(page_count = 20, offset = 0)
    self.scrawl = Scrawl.create
    timeout_count = 0
    pages = []
    old_i = 0

    ((offset + 1)..(offset + page_count)).each do |page_nb|
      pages << open_page(page_nb)
    end

    pages.each_with_index do |page, i|
      timeout_count = 0 if old_i != i

      begin
        page_message(i + offset + 1)
        scrawl_page(page)
      rescue Timeout::Error => e
        time_out_message(i)
        timeout_count += 1
        retry unless timeout_count > 2
      end

      old_i = i
    end

    scrawl.successful!
  rescue => e
    puts "Failure: #{e.message}\n#{e.backtrace}"
    scrawl.successful = false
    scrawl.save
  end

  def update_stats(scrawl, item)
    return unless scrawl && item
    scrawl.increment(:item_count)
    scrawl.save if scrawl.item_count % 500 == 0
  end

  def closing_thread(scrawl)
    scrawl.increment(:thread_count)
  end

  protected

  def scrawl_page page
    page.css(css[:root_table]).css("tr").each do |tr|
      index_thread(thread_id(tr), scrawl)
    end
  end

  def page_url(page)
    "#{forum_url}/page/#{page}"
  end

  def thread_id(thread_row)
    link = thread_row.css(css[:thread_title]).first
    link.attr("href").match(/(\d+)/).try(:[], 1) if link
  end

  def open_page(page)
    Nokogiri::HTML(open(page_url(page)))
  end

  def css
    @css ||= {
      root_table: "#view_forum_table",
      thread_title: ".title a"
    }
  end

  def time_out_message(i)
    puts %Q{
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      !!!!!!!!!!!!!!!!!!!!!!!!! TIMEOUT PAGE #{i} !!!!!!!!!!!!!!!!!!!!!
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    }
  end

  def page_message(i)
    puts %Q{
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
      //////////////////////////// PAGE #{i} //////////////////////////
      /////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////
    }
  end
end
