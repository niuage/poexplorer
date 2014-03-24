namespace :scrawler do

  def scrawl_league_by_id(league_id)
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

  desc "Scrawl path of exile forums"
  task :wts, [:page, :offset, :hardcore, :shop] => :environment do |t, args|
    args.with_defaults(page: 20, offset: 0, hardcore: 0, shop: 0)

    scrawler = Scrawler.new(args[:hardcore].to_i, args[:shop].to_i)
    scrawler.scrawl!(args[:page].to_i, args[:offset].to_i)
  end

  desc "Scrawl infintely"
  task :infinite => :environment do

    while true do
      puts "scrawl infinite new cycle"
      puts "#{League.permanent.count}"
      break if League.permanent.count == 0

      League.permanent.pluck(:id).each do |league_id|
        scrawl_league_by_id(league_id)
      end
    end
  end

  task :infinite_temp => :environment do

    while true do
      leagues = League.seasonal.visible

      puts "temp league scrawl new cycle"
      puts "#{leagues.count}"
      break if leagues.count == 0

      League.seasonal.visible.select("id, name").each do |league|
        puts "Scrawling #{league.name} league"
        scrawl_league_by_id(league.id)
      end
    end

  end

  task :scrawl_all, [:env,:page_count] => :environment do |t, args|
    page_count = args[:page_count] || 1
    tp = ThreadPool.new(4)

    for league in 0..1
      for shop in 0..1
        tp.schedule(page_count, league, shop, args[:env]) do |t_page_count, t_league, t_shop, t_env|
          puts "SCHEDULE #{t_league} #{t_shop}"
          ENV['RAILS_ENV'] = t_env
          Rake::Task["scrawler:wts"].reenable
          Rake::Task["scrawler:wts"].invoke(t_page_count, 0, t_league, t_shop)
        end
      end
    end

    puts 'yeah'
    # raise "SHUTING DOWN"
    tp.shutdown
  end
end

