namespace :crawler do

  def crawl_league_by_id(league_id)
    puts "scrawl league #{league_id}"

    0.upto(1) do |shop|
      puts "/////////////////////////"
      puts "CRAWLING: #{league_id}, #{shop} /////////////////////////"
      puts "/////////////////////////"
      scrawler = Crawler.new(league_id, shop)
      scrawler.scrawl!(1, 0)
    end
  end

  desc "Scrawl infintely"
  task :permanent => :environment do

    while true do
      puts "ccrawl infinite new cycle"
      break if League.permanent.count == 0

      League.permanent.pluck(:id).each do |league_id|
        crawl_league_by_id(league_id)
      end
    end
  end

  task :seasonal => :environment do
    while true do
      leagues = League.seasonal.visible

      puts "temp league crawl new cycle"
      break if leagues.count == 0

      League.seasonal.visible.select("id, name").each do |league|
        puts "Crawling #{league.name} league"
        crawl_league_by_id(league.id)
      end
    end
  end

end

