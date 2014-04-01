namespace :crawler do

  def crawl_league_by_id(league_id)
    league_id = league_id - 1
    return if league_id < 0
    puts "scrawl league #{league_id}"
    forums = Scrawler::FORUM_IDS[league_id]
    return unless forums

    0.upto(forums.length - 1) do |forum_id|
      scrawler = Scrawler.new(league_id, forum_id)
      scrawler.scrawl!(2, 0)
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

