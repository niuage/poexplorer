class Scrawler < Indexer

  attr_accessor :scrawl, :shop, :page, :league_id

  def initialize(league_id, shop = 0)
    self.league_id = league_id
    self.shop = shop
  end

  def scrawl!(page_count = 20, offset = 0)
    self.scrawl = Scrawl.create
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

  def scrawl_page(page)
    page.thread_ids.each do |thread_id|
      index_thread(thread_id, scrawl)
    end
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
