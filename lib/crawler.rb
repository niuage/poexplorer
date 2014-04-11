class Crawler

  POE_URL = "http://www.pathofexile.com"
  FORUM_ROOT = "#{POE_URL}/forum/view-forum"
  THREAD_ROOT = "#{POE_URL}/forum/view-thread"

  attr_accessor :league_id, :shop

  def initialize(league_id, shop = 0)
    self.league_id = league_id
    self.shop = shop
  end

  def scrawl!(page_count = 20, offset = 0)
    timeout_count = 0
    pages = []
    old_i = 0

    ((offset + 1)..(offset + page_count)).each do |page_nb|
      pages << ForumThreadPage.new(league_id, shop, page_nb)
    end

    pages.each_with_index do |page, i|
      timeout_count = 0 if old_i != i

      begin
        page_message(i + offset + 1)
        scrawl_page(page)
      rescue Timeout::Error => e
        Bugsnag.notify(e, {
          league_id: league_id,
          shop: shop
        })
        time_out_message(i)
        timeout_count += 1
        retry unless timeout_count > 2
      end

      old_i = i
    end
  end

  protected

  def scrawl_page(page)
    page.thread_ids.each { |id| ThreadIndexer.new(id).index }
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
