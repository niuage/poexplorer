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

  def error(message)
    RuntimeError.new(message)
  end

  def parse_old_forum_threads(league_id)
    puts "/////////////////////////"
    puts "PARSING OLD THREADS: #{league_id}"
    puts "/////////////////////////"

    ForumThread
      .where(league_id: league_id)
      .order('updated_at ASC')
      .limit(15)
      .each do |thread|
      ThreadIndexer.new(thread.uid).index
    end
  end

  desc "Scrawl infintely"
  task :permanent => :environment do
    File.open(ENV['PIDFILE'], 'w') { |f| f << Process.pid } if ENV['PIDFILE'].present?

    while true do
      break if League.permanent.count == 0

      finished_at = nil
      League.permanent.pluck("id, name").each do |league|
        started_at = Time.zone.now

        league_id = league[0]
        league_name = league[1]

        Bugsnag.notify(error("New cycle: #{league_name} #{started_at}"), {
          seasonal: false,
          started_at: started_at,
          last_finished_at: finished_at
        })

        crawl_league_by_id(league_id)

        finished_at = Time.zone.now

        parse_old_forum_threads(league_id)
        sleep(30)
      end
    end
  end

  task :seasonal => :environment do
    File.open(ENV['PIDFILE'], 'w') { |f| f << Process.pid } if ENV['PIDFILE'].present?
    while true do
      leagues = League.seasonal.visible

      break if leagues.count == 0

      finished_at = nil

      leagues.select("id, name").each do |league|
        next if league.name.in? League::MERGED_LEAGUES

        started_at = Time.zone.now

        Bugsnag.notify(error("New cycle: #{league.name} #{started_at}"), {
          seasonal: true,
          started_at: started_at,
          last_finished_at: finished_at
        })

        puts "Crawling #{league.name} league"
        crawl_league_by_id(league.id)

        finished_at = Time.zone.now

        parse_old_forum_threads(league.id)
      end
    end
  end

end

